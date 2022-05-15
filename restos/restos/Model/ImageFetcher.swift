////
////  ImageFetcher.swift
////  restos
////
////  Created by Agustin Sgarlata on 5/14/22.
////
//
//import Foundation
//import Combine
//import SwiftUI
//
////TODO: delete me
//class ImageFetcher: ObservableObject {
//    
//    @Published var image = Data()
//        
//    init(url: String) {
//        guard !url.isEmpty else {
//            return
//        }
//        dataRequest(with: url, objectType: Data.self) { (result: Result) in
//            switch result {
//            case .success(let object):
//                let tempImage = object
//                DispatchQueue.main.async {
//                    self.image = tempImage
//                }
//            case .failure(let error):
//                print(error)
//            }
//        }
//        
//    }
//}
