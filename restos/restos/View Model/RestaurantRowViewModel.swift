//
//  RestaurantRowViewModel.swift
//  restos
//
//  Created by Agustin Sgarlata on 5/15/22.
//

import SwiftUI

struct RestaurantRowViewModel: Identifiable {
                
    private let item: Restaurant
    
    var id: String {
        return item.uuid
    }
    
    var name: String {
        return item.name
    }
    
    var rating: Double {
        return item.aggregateRatings.thefork.ratingValue
    }
    
    var photoURL: String {
        return item.mainPhoto?.the160X120 ?? ""
    }
    
    func getAddress() -> String {
        return item.getFormattedAddress()
    }
    
    init(item: Restaurant) {
        self.item = item
    }
    
    func createFavoriteViewModel(restaurantRepository: RestaurantRepositoryProtocol) -> FavoriteViewModel {
        return FavoriteViewModel(item: item, restaurantRepository: restaurantRepository)
    }
}

extension RestaurantRowViewModel: Hashable {
    static func == (lhs: RestaurantRowViewModel, rhs: RestaurantRowViewModel) -> Bool {
        return lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.name)
    }
}
