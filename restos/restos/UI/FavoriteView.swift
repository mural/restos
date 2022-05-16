//
//  FavoriteView.swift
//  restos
//
//  Created by Agustin Sgarlata on 5/15/22.
//

import SwiftUI

struct FavoriteView: View {
    
    private let viewModel: FavoriteViewModel
    @State var isFav: Bool
    
    init(viewModel: FavoriteViewModel, isFav: Bool = false) {
        self.viewModel = viewModel
        self.isFav = isFav
        
        viewModel.checkFav()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            if (isFav) {
                Button(action: { viewModel.deleteResto() }) {
                    Image("filled-heart")
                        .frame(width: 60, height: 60)
                }
                .buttonStyle(.plain)
            } else {
                Button(action: { viewModel.addResto() }) {
                    Image("empty-heart")
                        .frame(width: 60, height: 60)
                }
                .buttonStyle(.plain)
            }
        }
        .onReceive(viewModel.$updatedFav) { fav in
            self.isFav = fav
        }
        
    }
}

struct FavoriteView_Previews: PreviewProvider {
    
    static var previews: some View {
        FavoriteView(viewModel: FavoriteViewModel(item: restaurantItemPreview, restaurantRepository: RestaurantRepositoryImplementation(restaurantService: RestaurantAPI(), managedObjectContext: PersistenceController.shared.container.viewContext)), isFav: false)
        
        FavoriteView(viewModel: FavoriteViewModel(item: restaurantItemPreview, restaurantRepository: RestaurantRepositoryImplementation(restaurantService: RestaurantAPI(), managedObjectContext: PersistenceController.shared.container.viewContext)), isFav: true)
    }
}
