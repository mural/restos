//
//  Extensions.swift
//  restos
//
//  Created by Agustin Sgarlata on 5/17/22.
//

import UIKit
import MapKit

extension UIView {
    
    func anchor (top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat, enableInsets: Bool) {
        var topInset = CGFloat(0)
        var bottomInset = CGFloat(0)
        
        if enableInsets {
            let insets = self.safeAreaInsets
            topInset = insets.top
            bottomInset = insets.bottom
        }
                
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop+topInset).isActive = true
        }
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom-bottomInset).isActive = true
        }
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
    }
    
}

@propertyWrapper
public struct UsesAutoLayout<T: UIView> {
    public var wrappedValue: T {
        didSet {
            wrappedValue.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
        wrappedValue.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension UILabel {
    
    static func createBasicLabel(text: String = "", textColor: UIColor = UIColor.label, font: UIFont = UIFont.systemFont(ofSize: 16), textAlignment: NSTextAlignment = NSTextAlignment.left) -> UILabel {
        @UsesAutoLayout
        var label = UILabel()
        label.text = text
        label.numberOfLines = 0
        label.textColor = .label
        label.font = font
        label.textAlignment = textAlignment
        return label
    }
    
    static func createSubTitleLabel(text: String = "", textAlignment: NSTextAlignment = NSTextAlignment.center) -> UILabel {
        return createBasicLabel(text: text, font: UIFont.boldSystemFont(ofSize: 16), textAlignment: textAlignment)
    }
    
    static func createTitleLabel(text: String = "") -> UILabel {
        return createBasicLabel(text: text, font: UIFont.boldSystemFont(ofSize: 26), textAlignment: NSTextAlignment.center)
    }
    
    func add(image: UIImage, text: String, isLeading: Bool = true, imageBounds: CGRect = CGRect(x: 0, y: 0, width: 16, height: 16)) {
        let imageAttachment = NSTextAttachment()
        imageAttachment.bounds = imageBounds
        imageAttachment.image = image
        
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        let string = NSMutableAttributedString(string: text)
        let mutableAttributedString = NSMutableAttributedString()
        if isLeading {
            mutableAttributedString.append(attachmentString)
            mutableAttributedString.append(string)
            attributedText = mutableAttributedString
        } else {
            string.append(attachmentString)
            attributedText = string
        }
    }
}

extension UIStackView {

    static func createStackView(views: [UIView],
                                axis: NSLayoutConstraint.Axis = NSLayoutConstraint.Axis.vertical,
                                alignment: UIStackView.Alignment = UIStackView.Alignment.center,
                                distribution: UIStackView.Distribution = UIStackView.Distribution.fill,
                                spacing: CGFloat = 5) -> UIStackView {
        
        @UsesAutoLayout
        var stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = axis
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackView.spacing = spacing
        return stackView
    }
}

extension MKMapView {
    
    func setMapWithGeocoderFromAdress(geocoder: CLGeocoder, address: String) {
        geocoder.geocodeAddressString(address) { [self] placemarks, error in
            if let placemark = placemarks?.first, let location = placemark.location {
                
                let placeMark = RestoPlace(title: address, coordinate: location.coordinate)
                addAnnotation(placeMark)
                
                let span = MKCoordinateSpan.init(latitudeDelta: 0.0015, longitudeDelta: 0.0015)
                let region = MKCoordinateRegion(center: location.coordinate, span: span)
                setRegion(region, animated: true)
            }
        }
    }
    
}

extension UIImageView {
    
    static func imagePlaceholder() -> UIImage {
        return UIImage(#imageLiteral(resourceName: "image-placeholder"))
    }
    
    static func imageEmptyHeart() -> UIImage {
        return UIImage(#imageLiteral(resourceName: "empty-heart"))
    }
    
    static func imageFilledHeart() -> UIImage {
        return UIImage(#imageLiteral(resourceName: "filled-heart"))
    }
    
    static func createBasicImage() -> UIImageView {
        @UsesAutoLayout
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }
    
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.image = UIImageView.imagePlaceholder()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self?.image = UIImageView.imagePlaceholder()
                }
            }
        }
    }
}
