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
    private let restaurantRepository: RestaurantRepositoryProtocol
    
    init(viewModel: RestaurantRowViewModel, restaurantRepository: RestaurantRepositoryProtocol) {
        self.viewModel = viewModel
        self.restaurantRepository = restaurantRepository
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                HStack {  
                    let url = URL(string: viewModel.photoURL)
                    if (url != nil) {
                        URLImage(url!) {
                            EmptyView()
                        } inProgress: { progress in
                            ActivityIndicator(style: .medium)
                        } failure: { error, retry in
                            imagePlaceholder
                        } content: { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 120, height: 80, alignment: .center)
                        }
                    } else {
                        imagePlaceholder
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

private extension RestaurantRowView {
    var imagePlaceholder: some View {
        Image("image-placeholder")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 120, height: 80, alignment: .center)
    }
    
    var emptySection: some View {
        Section {
            Text("No restaurants")
                .foregroundColor(.gray)
        }
    }
    
}

let restaurantItemPreview = Restaurant(name: "Restaurant name", uuid: "", servesCuisine: "Special", priceRange: 0, currenciesAccepted: "All", address: Address(street: "Street", postalCode: "12012", locality: "City", country: "Country"), aggregateRatings: AggregateRatings(thefork: RatingDetails(ratingValue: 4.4, reviewCount: 44), tripadvisor: RatingDetails(ratingValue: 3.3, reviewCount: 33)), mainPhoto: nil, bestOffer:  BestOffer.init(name: "Offer", label: "All 40%"))

struct RestaurantRowView_Previews: PreviewProvider {
    static var previews: some View {
        let repository = RestaurantRepositoryImplementation(restaurantService: RestaurantAPI(), managedObjectContext: PersistenceController.shared.container.viewContext)
        let viewModel = RestaurantRowViewModel(item: restaurantItemPreview)
        
        RestaurantRowView(viewModel: viewModel, restaurantRepository: repository)
    }
}
