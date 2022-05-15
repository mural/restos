//
//  restosTests.swift
//  restosTests
//
//  Created by Agustin Sgarlata on 5/13/22.
//

import XCTest
@testable import restos
import Combine

class MockRestaurantRepository: RestaurantRepository {
    
    var fetchResult: AnyPublisher<RestaurantsData, AppError>!

    func getRestaurants() -> AnyPublisher<RestaurantsData, AppError> {
        fetchResult
    }
    
    func getFavoritesRestaurants() -> [String] {
        return [""]
    }
    
    func addRestaurantOnFavorites(uuid: String) {
    }
    
    func removeRestaurantFromFavorites(uuid: String) {
    }
    
}

class restosTests: XCTestCase {

    let restaurantItem = Restaurant(name: "Restaurant name", uuid: "", servesCuisine: "Special", priceRange: 0, currenciesAccepted: "All", address: Address(street: "Street", postalCode: "12012", locality: "City", country: "Country"), aggregateRatings: AggregateRatings(thefork: Thefork(ratingValue: 4.4, reviewCount: 44), tripadvisor: Thefork(ratingValue: 3.3, reviewCount: 33)), mainPhoto: nil, bestOffer:  BestOffer.init(name: "Offer", label: "All 40%"))
    
    private var restaurantViewModel: RestaurantViewModel!
    private var restaurantRepository: MockRestaurantRepository!
    private var cancellables: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        restaurantRepository = MockRestaurantRepository()
        restaurantViewModel = RestaurantViewModel(restaurantRepository: restaurantRepository)
        
    }

    override func tearDownWithError() throws {
        restaurantViewModel = nil
        restaurantRepository = nil
        
        try super.tearDownWithError()
    }

    func testExample() throws {
        let expectation = XCTestExpectation(description: "State is set to populated")
        
        restaurantViewModel.$state.dropFirst(2).sink { viewState in
            XCTAssertEqual(viewState, .success(RestaurantsData(data: [self.restaurantItem]).data.map { restaurant in
                    RestaurantRowViewModel.init(item: restaurant)
                }))
            expectation.fulfill()
            
        }.store(in: &cancellables)
        
        restaurantRepository.fetchResult = Result.success(RestaurantsData(data: [self.restaurantItem])).publisher.eraseToAnyPublisher()
        restaurantViewModel.fetchRestos()
        
        wait(for: [expectation], timeout: 3)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
