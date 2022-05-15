//
//  repositoryTests.swift
//  restosTests
//
//  Created by Agustin Sgarlata on 5/15/22.
//

import XCTest
@testable import restos
import Combine

class MockRestaurantService: RestaurantService {
    
    var response: AnyPublisher<RestaurantsData, AppError>!
    
    func getRestaurants() -> AnyPublisher<RestaurantsData, AppError> {
        response
    }
    
}

class repositoryTests: XCTestCase {

    let restaurantItem = Restaurant(name: "Restaurant name", uuid: "", servesCuisine: "Special", priceRange: 0, currenciesAccepted: "All", address: Address(street: "Street", postalCode: "12012", locality: "City", country: "Country"), aggregateRatings: AggregateRatings(thefork: Thefork(ratingValue: 4.4, reviewCount: 44), tripadvisor: Thefork(ratingValue: 3.3, reviewCount: 33)), mainPhoto: nil, bestOffer:  BestOffer.init(name: "Offer", label: "All 40%"))
    
    private var restaurantRepository: RestaurantRepository!
    private var restaurantService: MockRestaurantService!
    private var cancellables: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        restaurantService = MockRestaurantService()
        restaurantRepository = RestaurantRepositoryImplementation.init(restaurantService: restaurantService, managedObjectContext: PersistenceController.shared.container.viewContext)
        
    }

    override func tearDownWithError() throws {
        restaurantService = nil
        restaurantRepository = nil
        
        try super.tearDownWithError()
    }

    func testExample() throws {
        let expectation = XCTestExpectation(description: "restaurants is with data")
        
        var restaurantsData = RestaurantsData.loadFromFile(type(of: self), fileName: "restaurants", type: "json")
        restaurantService.response = Result.success(restaurantsData).publisher.eraseToAnyPublisher()
        
        //restaurantsData = RestaurantsData(data: restaurantsData.data.dropLast()) //TODO: create failing test with this one
        
        restaurantRepository.getRestaurants().sink(receiveCompletion: { _ in }, receiveValue: { value in
            XCTAssertEqual(value, restaurantsData)
            expectation.fulfill()
            
        }).store(in: &cancellables)
        
        wait(for: [expectation], timeout: 3)
    }

}

extension Decodable {
    static func loadFromFile(_ bundleType: AnyClass, fileName resource: String, type: String) -> Self {
        do {
            let path = Bundle(for: bundleType).path(forResource: resource, ofType: type)!
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            return try JSONDecoder().decode(Self.self, from: data)
        } catch {
            fatalError("Error: \(error)")
        }
    }
}

