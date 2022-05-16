//
//  RestaurantsData.swift
//  restos
//
//  Created by Agustin Sgarlata on 5/15/22.
//

import Foundation

// MARK: - RestaurantsData
struct RestaurantsData: Codable, Equatable {
    let data: [Restaurant]
    
    static func == (lhs: RestaurantsData, rhs: RestaurantsData) -> Bool {
        lhs.data == rhs.data
    }
}

// MARK: - Restaurant
struct Restaurant: Codable, Identifiable, Equatable {
    let id: UUID? = UUID()
    let name, uuid, servesCuisine: String
    let priceRange: Int
    let currenciesAccepted: String
    let address: Address
    let aggregateRatings: AggregateRatings
    let mainPhoto: MainPhoto?
    let bestOffer: BestOffer
    
    static func == (lhs: Restaurant, rhs: Restaurant) -> Bool {
        lhs.id == rhs.id
    }
    
    func getFormattedAddress() -> String {
        return "\(address.street), \(address.postalCode), \(address.locality), \(address.country)"
    }
}

// MARK: - Address
struct Address: Codable {
    let street, postalCode: String
    let locality: String
    let country: String
}

// MARK: - AggregateRatings
struct AggregateRatings: Codable {
    let thefork, tripadvisor: RatingDetails
}

// MARK: - RatingDetails
struct RatingDetails: Codable {
    let ratingValue: Double
    let reviewCount: Int
}

// MARK: - BestOffer
struct BestOffer: Codable {
    let name: String
    let label: String
}

// MARK: - MainPhoto
struct MainPhoto: Codable {
    let source, the612X344, the480X270, the240X135: String
    let the664X374, the1350X759, the160X120, the80X60: String
    let the92X92, the184X184: String

    enum CodingKeys: String, CodingKey {
        case source
        case the612X344 = "612x344"
        case the480X270 = "480x270"
        case the240X135 = "240x135"
        case the664X374 = "664x374"
        case the1350X759 = "1350x759"
        case the160X120 = "160x120"
        case the80X60 = "80x60"
        case the92X92 = "92x92"
        case the184X184 = "184x184"
    }
}
