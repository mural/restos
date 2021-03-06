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
    private let restaurantRepository: RestaurantRepositoryProtocol
    
    init(item: Restaurant, restaurantRepository: RestaurantRepositoryProtocol) {
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
