//
//  RestaurantsView.swift
//  restos
//
//  Created by Agustin Sgarlata on 5/15/22.
//

import SwiftUI

struct RestaurantsView: View {
    
    @ObservedObject var viewModel: RestaurantViewModel
    var restaurantRepository: RestaurantRepository
    
    init(viewModel: RestaurantViewModel, restaurantRepository: RestaurantRepository) {
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
                Text("Error...")
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
            Text("Loading...")
                .foregroundColor(.gray)
        }
    }
    
    var emptySection: some View {
        Section {
            Text("No restaurants")
                .foregroundColor(.gray)
        }
    }
    
}

struct RestaurantView: View {
    var data: [RestaurantRowViewModel]
    var restaurantRepository: RestaurantRepository
    
    init(data: [RestaurantRowViewModel], restaurantRepository: RestaurantRepository) {
        self.data = data
        self.restaurantRepository = restaurantRepository
    }
    
    var body: some View {
        Section {
            ForEach(data) {
                restaurantRowViewModel in
                NavigationLink {
                    Text(restaurantRowViewModel.item.name)
                    
                    let address = restaurantRowViewModel.item.address  //TODO: use model !
                    let formattedAddress = "\(address.street), \(address.postalCode), \(address.locality), \(address.country)"
                    MapView(address: formattedAddress)
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
