//
//  RestaurantsView.swift
//  restos
//
//  Created by Agustin Sgarlata on 5/15/22.
//

import SwiftUI

struct RestaurantsView: View {
    
    @ObservedObject var viewModel: RestaurantViewModel
    var restaurantRepository: RestaurantRepositoryProtocol
    
    init(viewModel: RestaurantViewModel, restaurantRepository: RestaurantRepositoryProtocol) {
        self.viewModel = viewModel
        self.restaurantRepository = restaurantRepository
    }
    
    var body: some View {
        NavigationView {
            switch viewModel.state {
            case .idle:
                Color.clear.onAppear(perform: viewModel.fetchRestos)
            case .loading:
                ActivityIndicator(style: .large)
            case .failure:
                Text("There was an error trying to download the Restaurants, please try again later.")
            case .success(let data):
                List {
                    if data.isEmpty {
                        emptySection
                    } else {
                        RestaurantView.init(data: data, restaurantRepository: restaurantRepository)
                    }
                }
                .listStyle(GroupedListStyle())
                .navigationBarTitle("Restos 🍽")
            }
            
        }
    }
    
}

private extension RestaurantsView {
    var loadingSection: some View {
        Section {
            Text("Loading Restaurants...")
                .foregroundColor(.gray)
        }
    }
    
    var emptySection: some View {
        Section {
            Text("No Restaurants")
                .foregroundColor(.gray)
        }
    }
    
}

struct RestaurantView: View {
    var data: [RestaurantRowViewModel]
    var restaurantRepository: RestaurantRepositoryProtocol
    
    init(data: [RestaurantRowViewModel], restaurantRepository: RestaurantRepositoryProtocol) {
        self.data = data
        self.restaurantRepository = restaurantRepository
    }
    
    var body: some View {
        Section {
            ForEach(data) {
                restaurantRowViewModel in
                NavigationLink {
                    Text(restaurantRowViewModel.item.name)

                    MapView(address: restaurantRowViewModel.item.getFormattedAddress())
                        .frame(width: 400, height: 260, alignment: .topLeading)
                } label: {
                    RestaurantRowView.init(viewModel: restaurantRowViewModel, restaurantRepository: restaurantRepository)
                }
            }
        }
    }
}

struct RestaurantsView_Previews: PreviewProvider {
    static var previews: some View {
        let repository = RestaurantRepositoryImplementation(restaurantService: RestaurantAPI(), managedObjectContext: PersistenceController.shared.container.viewContext)
        let viewModel = RestaurantViewModel(restaurantRepository: repository)
        
        RestaurantsView(viewModel: viewModel, restaurantRepository: repository)
    }
}
