//
//  RestaurantFetcher.swift
//  restos
//
//  Created by Agustin Sgarlata on 5/15/22.
//

import Foundation
import Combine

enum AppError: Error, Equatable {
    case network(description: String)
    case parsing(description: String)
}

protocol RestaurantServiceProtocol {
    func getRestaurants() -> AnyPublisher<RestaurantsData, AppError>
}

class RestaurantAPI {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
}

extension RestaurantAPI: RestaurantServiceProtocol {
    func getRestaurants() -> AnyPublisher<RestaurantsData, AppError> {
        return restosAPICall(with: makeRestosComponents())
    }
    
    
    private func restosAPICall<T>(
        with components: URLComponents
    ) -> AnyPublisher<T, AppError> where T: Decodable {
        guard let url = components.url else {
            let error = AppError.network(description: "Couldn't create URL")
            return Fail(error: error).eraseToAnyPublisher()
        }
        return session.dataTaskPublisher(for: URLRequest(url: url))
            .mapError { error in
                    .network(description: error.localizedDescription)
            }
            .flatMap(maxPublishers: .max(1)) { pair in
                decode(pair.data)
            }
            .eraseToAnyPublisher()
    }
}

private extension RestaurantAPI {
    struct RestosComponents {
        static let scheme = "https"
    }
    
    func makeRestosComponents() -> URLComponents {
        var components = URLComponents()
        components.scheme = RestosComponents.scheme
        components.host = BundleUtils.getAPIParams(param: "API_HOST")
        components.path = BundleUtils.getAPIParams(param: "API_PATH")
        
        return components
    }
}


