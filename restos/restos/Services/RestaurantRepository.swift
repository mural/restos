//
//  RestaurantRepository.swift
//  restos
//
//  Created by Agustin Sgarlata on 5/15/22.
//
import Combine
import CoreData

protocol RestaurantRepositoryProtocol {
    func getRestaurants() -> AnyPublisher<RestaurantsData, AppError>
    func getFavoritesRestaurants() -> [String]
    func addRestaurantOnFavorites(uuid: String)
    func removeRestaurantFromFavorites(uuid: String)
}

class RestaurantRepositoryImplementation : RestaurantRepositoryProtocol {
    
    var restaurantFavoritesEntities: [RestaurantEntity] = []
    private var fetchRequest : NSFetchRequest<RestaurantEntity> = RestaurantEntity.fetchRequest()
    private var restaurantFavoritesUUIDs = [""]
    private let restaurantService: RestaurantServiceProtocol
    private let managedObjectContext: NSManagedObjectContext
    private let lock = NSRecursiveLock()
    
    init(
        restaurantService: RestaurantServiceProtocol,
        managedObjectContext: NSManagedObjectContext
    ) {
        self.restaurantService = restaurantService
        self.managedObjectContext = managedObjectContext
    }
    
    func getFavoritesRestaurants() -> [String] {
        do {
            fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \RestaurantEntity.uuid, ascending: true)]
            restaurantFavoritesEntities = try managedObjectContext.fetch(fetchRequest)
            
            restaurantFavoritesUUIDs = restaurantFavoritesEntities.map { restaurantEntity in
                restaurantEntity.uuid ?? ""
            }
            
            return restaurantFavoritesUUIDs
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return [""]
    }
    
    func getRestaurants() -> AnyPublisher<RestaurantsData, AppError> {
        return restaurantService.getRestaurants()
    }
    
    func addRestaurantOnFavorites(uuid: String) {
        lock.lock()
        do {
            fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \RestaurantEntity.uuid, ascending: true)]
            restaurantFavoritesEntities = try managedObjectContext.fetch(fetchRequest)
            
            guard (restaurantFavoritesEntities.first(where: { entity in
                entity.uuid == uuid
            }) != nil) else {
                let newItem = RestaurantEntity(context: managedObjectContext)
                newItem.uuid = uuid
                
                do {
                    try managedObjectContext.save()
                    lock.unlock()
                } catch {
                    // Improve this with proper error handling
                    print(error.localizedDescription)
                    lock.unlock()
                }
                return
            }
        } catch {
            // Improve this with proper error handling
            print(error.localizedDescription)
            lock.unlock()
        }
        lock.unlock()
    }
    
    func removeRestaurantFromFavorites(uuid: String) {
        lock.lock()
        do {
            fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \RestaurantEntity.uuid, ascending: true)]
            restaurantFavoritesEntities = try managedObjectContext.fetch(fetchRequest)
            
            if let entity = restaurantFavoritesEntities.first(where: { entity in
                entity.uuid == uuid
            }) {
                managedObjectContext.delete(entity)
                
                do {
                    try managedObjectContext.save()
                    lock.unlock()
                } catch {
                    // Improve this with proper error handling
                    print(error.localizedDescription)
                    lock.unlock()
                }
            }
        } catch {
            // Improve this with proper error handling
            print(error.localizedDescription)
            lock.unlock()
        }
    }
}
