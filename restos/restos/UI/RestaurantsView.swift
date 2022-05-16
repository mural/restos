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
                    Text(restaurantRowViewModel.name)
                        .font(.largeTitle)
                        .fontWeight(Font.Weight.heavy)
                        .padding()
                        .animation(.spring())
                    
                    Text("Rating: \(String(restaurantRowViewModel.rating))")
                    HStack {
                        let baseRatingRaw = Int(restaurantRowViewModel.rating)
                        let baseRating = baseRatingRaw > 0 ? baseRatingRaw : 0
                        ForEach(0..<baseRating, id: \.self) { index in
                            Image("ta-bubbles-full")
                        }
                        let decimalRating = restaurantRowViewModel.rating.truncatingRemainder(dividingBy: 1)
                        if decimalRating >= 0.5 {
                            Image("ta-bubbles-half")
                        } else {
                            Image("ta-bubbles-empty")
                        }
                        let completeRating = 10 - baseRating
                        ForEach(1..<completeRating, id: \.self) { index in
                            Image("ta-bubbles-empty")
                        }
                    }
                    
                    HStack {
                        Image("location")
                        Text(restaurantRowViewModel.getAddress())
                            .foregroundColor(Color.secondary)
                            .padding()
                    }

                    MapView(address: restaurantRowViewModel.getAddress())
                        .frame(width: 400, height: 260, alignment: .topLeading)
                } label: {
                    RestaurantRowView.init(viewModel: restaurantRowViewModel, favoriteViewModel: restaurantRowViewModel.createFavoriteViewModel(restaurantRepository: restaurantRepository))
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
