//
//  DetailViewController.swift
//  restos
//
//  Created by Agustin Sgarlata on 5/17/22.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {

    private var restaurantRowViewModel: RestaurantRowViewModel
    
    required init?(restaurantRowViewModel: RestaurantRowViewModel) {
        self.restaurantRowViewModel = restaurantRowViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let nameLabel = UILabel.createTitleLabel(text: restaurantRowViewModel.name)
        
        let adressLabel = UILabel.createSubTitleLabel(text: "")
        adressLabel.add(image: UIImage(#imageLiteral(resourceName: "location")), text: "\(String.init(restaurantRowViewModel.getAddress()))")
        
        let geocoder = CLGeocoder()
        @UsesAutoLayout
        var mapView = MKMapView()
        mapView.setMapWithGeocoderFromAdress(geocoder: geocoder, address: restaurantRowViewModel.getAddress())
        
        let stackViewInfo = UIStackView.createStackView(views: [nameLabel, adressLabel, mapView])
        view.addSubview(stackViewInfo)
        
        stackViewInfo.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 60, paddingLeft: 40, paddingBottom: 60, paddingRight: 40, width: 0, height: 0, enableInsets: false)
        mapView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 500, height: 300, enableInsets: false)
    }
}
