//
//  RestaurantViewModel.swift
//  restos
//
//  Created by Agustin Sgarlata on 5/15/22.
//

import SwiftUI
import Combine
import CoreData

enum ViewModelStates: Equatable {
    case idle
    case loading
    case success([RestaurantRowViewModel])
    case failure
}

class RestaurantViewModel: ObservableObject {
    @Published private(set) var state = ViewModelStates.idle
    private let restaurantRepository: RestaurantRepositoryProtocol
    private var disposables = Set<AnyCancellable>()
    
    init(
        restaurantRepository: RestaurantRepositoryProtocol
    ) {
        self.restaurantRepository = restaurantRepository
    }
    
    func fetchRestos() {
        state = .loading
        
        restaurantRepository.getRestaurants()
            .map { response in
                response.data.map { restaurant in
                    RestaurantRowViewModel.init(item: restaurant)
                }.sorted { restaurantRowViewModel1, restaurantRowViewModel2 in
                    restaurantRowViewModel1.item.aggregateRatings.thefork.ratingValue
                    > restaurantRowViewModel2.item.aggregateRatings.thefork.ratingValue
                }
            }
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] value in
                    guard let self = self else { return }
                    switch value {
                    case .failure:
                        self.state = .failure
                    case .finished:
                        break
                    }
                },
                receiveValue: { [weak self] restos in
                    guard let self = self else { return }
                    self.state = .success(restos)
                })
            .store(in: &disposables)
    }
}

extension RestaurantViewModel {
    var currentView: some View {
        return RestaurantBuilder.makeRestaurantView(
            restaurantRepository: restaurantRepository
        )
    }
}

enum RestaurantBuilder {
    static func makeRestaurantView(
        restaurantRepository: RestaurantRepositoryProtocol
    ) -> some View {
        let viewModel = RestaurantViewModel(
            restaurantRepository: restaurantRepository)
        return RestaurantsView(viewModel: viewModel, restaurantRepository: restaurantRepository)
    }
}
