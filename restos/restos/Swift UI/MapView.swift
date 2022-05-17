//
//  MapView.swift
//  restos
//
//  Created by Agustin Sgarlata on 5/15/22.
//

import SwiftUI
import MapKit

class RestoPlace: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
}

struct MapView: UIViewRepresentable {
    let geocoder = CLGeocoder()
    let mapView = MKMapView()
    
    var address: String
    init(address: String) {
        self.address = address
    }
    
    func makeUIView(context: Context) -> MKMapView {
        mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        mapView.setMapWithGeocoderFromAdress(geocoder: geocoder, address: address)
    }
}
 
