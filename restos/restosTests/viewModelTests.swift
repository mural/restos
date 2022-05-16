//
//  restosTests.swift
//  restosTests
//
//  Created by Agustin Sgarlata on 5/13/22.
//

import XCTest
@testable import restos
import Combine

class MockRestaurantRepository: RestaurantRepositoryProtocol {
    
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

class viewModelTests: XCTestCase {

    let restaurantItem = Restaurant(name: "Restaurant name", uuid: "", servesCuisine: "Special", priceRange: 0, currenciesAccepted: "All", address: Address(street: "Street", postalCode: "12012", locality: "City", country: "Country"), aggregateRatings: AggregateRatings(thefork: RatingDetails(ratingValue: 4.4, reviewCount: 44), tripadvisor: RatingDetails(ratingValue: 3.3, reviewCount: 33)), mainPhoto: nil, bestOffer:  BestOffer.init(name: "Offer", label: "All 40%"))
    
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

    func test_viewmodel_loading_state() throws {
        let expectation = XCTestExpectation(description: "State is set to loading")
        
        restaurantViewModel.$state.dropFirst(1).sink { viewState in
            XCTAssertEqual(viewState, .loading)
            expectation.fulfill()
            
        }.store(in: &cancellables)
        
        restaurantRepository.fetchResult = Result.success(RestaurantsData(data: [self.restaurantItem])).publisher.eraseToAnyPublisher()
        restaurantViewModel.fetchRestos()
        
        wait(for: [expectation], timeout: 3)
    }
    
    func test_viewmodel_success_state_with_data() throws {
        let expectation = XCTestExpectation(description: "State is set to success with data")
        
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
    
    func test_viewmodel_error_state_no_data() throws {
        let expectation = XCTestExpectation(description: "State is set to failure")
        
        restaurantViewModel.$state.dropFirst(2).sink { viewState in
            XCTAssertEqual(viewState, .failure)
            expectation.fulfill()
            
        }.store(in: &cancellables)
        
        restaurantRepository.fetchResult = Result.failure(AppError.network(description: "")).publisher.eraseToAnyPublisher()
        restaurantViewModel.fetchRestos()
        
        wait(for: [expectation], timeout: 3)
    }

}
