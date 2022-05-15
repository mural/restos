//
//  RestaurantRepository.swift
//  restos
//
//  Created by Agustin Sgarlata on 5/15/22.
//
import Combine
import CoreData

protocol RestaurantRepository {
    func getRestaurants() -> AnyPublisher<RestaurantsData, AppError>
    func getFavoritesRestaurants() -> [String]
    func addRestaurantOnFavorites(uuid: String)
    func removeRestaurantFromFavorites(uuid: String)
}

class RestaurantRepositoryImplementation : RestaurantRepository {
        
    private let restaurantService: RestaurantService
    private let managedObjectContext: NSManagedObjectContext
    
    init(
        restaurantService: RestaurantService,
        managedObjectContext: NSManagedObjectContext
    ) {
        self.restaurantService = restaurantService
        self.managedObjectContext = managedObjectContext
    }
    
    private var fetchRequest : NSFetchRequest<RestaurantEntity> = RestaurantEntity.fetchRequest()
    
    @Published var restaurantFavoritesEntities: [RestaurantEntity] = []
    private var restaurantFavoritesUUIDs = [""]
    
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
        let newItem = RestaurantEntity(context: managedObjectContext)
        newItem.uuid = uuid

        do {
            try managedObjectContext.save()
        } catch {
            // Improve this with proper error handling
            print(error.localizedDescription)
        }
    }
    
    func removeRestaurantFromFavorites(uuid: String) {
        managedObjectContext.delete( restaurantFavoritesEntities.first { entity in
            entity.uuid == uuid
        }!)

        do {
            try managedObjectContext.save()
        } catch {
            // Improve this with proper error handling
            print(error.localizedDescription)
        }
    }
}
