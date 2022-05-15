//
//  RestaurantFetcher.swift
//  restos
//
//  Created by Agustin Sgarlata on 5/15/22.
//

import Foundation
import Combine

//AppError enum which shows all possible errors
enum AppError: Error {
    case network(description: String)
    case parsing(description: String)
}

//Result enum to show success or failure
enum Result<T> {
    case success(T)
    case failure(AppError)
}

protocol RestaurantService {
    func getRestaurants() -> AnyPublisher<RestaurantsData, AppError>
}

class RestaurantAPI {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
}

extension RestaurantAPI: RestaurantService {
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
    static let host = "alanflament.github.io"
    static let path = "/TFTest/test.json"
  }
  
  func makeRestosComponents() -> URLComponents {
    var components = URLComponents()
    components.scheme = RestosComponents.scheme
    components.host = RestosComponents.host
    components.path = RestosComponents.path
    
    return components
  }
}


