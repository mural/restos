//
//  RestaurantRowView.swift
//  restos
//
//  Created by Agustin Sgarlata on 5/15/22.
//

import SwiftUI
import URLImage

struct RestaurantRowView: View {
    
    private let viewModel: RestaurantRowViewModel
    private let restaurantRepository: RestaurantRepository
    
    init(viewModel: RestaurantRowViewModel, restaurantRepository: RestaurantRepository) {
        self.viewModel = viewModel
        self.restaurantRepository = restaurantRepository
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                HStack {
                    
                    let url = URL(string: viewModel.photoURL)
                    if (url != nil) { //TODO: ver estos checks
                        URLImage(url!) {
                            // This view is displayed before download starts
                            EmptyView()
                        } inProgress: { progress in
                            // Display progress
                            ActivityIndicator(style: .medium)
                        } failure: { error, retry in
                            // Display error and retry button
                            VStack {
                                Text(error.localizedDescription)
                                Button("Retry", action: retry)
                            }
                        } content: { image in
                            // Downloaded image
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 120, height: 80, alignment: .topLeading)
                        }
                    } else {
                        Image("ta-logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 120, height: 80, alignment: .topLeading)
                    }
                    
                    VStack(alignment: .leading) {
                        Text(viewModel.name)
                            .foregroundColor(Color.primary)
                            
                        Text("Rating: \(viewModel.rating)")
                            .foregroundColor(Color.secondary)
                    }
                    
                    Spacer()
                    
                    FavoriteView(viewModel: FavoriteViewModel(item: viewModel.item, restaurantRepository: restaurantRepository))
                }
            }
        }
    }
}

//TODO: ver mejor lugar para esto
let restaurantItem = Restaurant(name: "Restaurant name", uuid: "", servesCuisine: "Special", priceRange: 0, currenciesAccepted: "All", address: Address(street: "Street", postalCode: "12012", locality: "City", country: "Country"), aggregateRatings: AggregateRatings(thefork: Thefork(ratingValue: 4.4, reviewCount: 44), tripadvisor: Thefork(ratingValue: 3.3, reviewCount: 33)), mainPhoto: nil, bestOffer:  BestOffer.init(name: "Offer", label: "All 40%"))

struct RestaurantRowView_Previews: PreviewProvider {
    static var previews: some View {
        let repository = RestaurantRepositoryImplementation(restaurantService: RestaurantAPI(), managedObjectContext: PersistenceController.shared.container.viewContext)
        let viewModel = RestaurantRowViewModel(item: restaurantItem)
        
        RestaurantRowView(viewModel: viewModel, restaurantRepository: repository)
    }
}
