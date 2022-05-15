//
//  FavoriteViewModel.swift
//  restos
//
//  Created by Agustin Sgarlata on 5/15/22.
//

import SwiftUI

class FavoriteViewModel: Identifiable, ObservableObject {
    
    @Published var updatedFav: Bool = false
        
    private let item: Restaurant
    private let restaurantRepository: RestaurantRepository
    
    var id: String {
        return item.uuid
    }
    
    var name: String {
        return item.name
    }
    
    var photoURL: String {
        return item.mainPhoto?.the160X120 ?? ""
    }
    
    init(item: Restaurant, restaurantRepository: RestaurantRepository) {
        self.item = item
        self.restaurantRepository = restaurantRepository
    }
    
    func checkFav() {
        updatedFav = restaurantRepository.getFavoritesRestaurants().contains(item.uuid)
    }
 
    func addResto() {
        restaurantRepository.addRestaurantOnFavorites(uuid: item.uuid)
        
        updatedFav = true
    }
    
    func deleteResto() {
        restaurantRepository.removeRestaurantFromFavorites(uuid: item.uuid)
        
        updatedFav = false
    }
}
