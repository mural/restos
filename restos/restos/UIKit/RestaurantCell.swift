//
//  RestaurantCell.swift
//  restos
//
//  Created by Agustin Sgarlata on 5/17/22.
//

import UIKit
import Combine

class RestaurantCell : UITableViewCell {
    
    private var cancellables: Set<AnyCancellable> = []
    
    private let nameLabel = UILabel.createSubTitleLabel()
    private let ratingLabel = UILabel.createBasicLabel()
    private let addressLabel = UILabel.createBasicLabel()

    private let imagePlaceholder = UIImageView.imagePlaceholder()
    private let imageEmptyHeart = UIImageView.imageEmptyHeart()
    private let imageFilledHeart = UIImageView.imageFilledHeart()
    
    private let (restaurantImage) = UIImageView.createBasicImage()
    private let (favoriteImage): UIImageView = UIImageView.createBasicImage()
    
    let containerView: UIView = {
        @UsesAutoLayout
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    var restaurantRowViewModel : RestaurantRowViewModel? {
        didSet {
            if (URL.init(string: restaurantRowViewModel?.photoURL ?? "") != nil) {
                (restaurantImage).load(url: URL.init(string: restaurantRowViewModel?.photoURL ?? "")!)
            } else {
                (restaurantImage).image = imagePlaceholder
            }
            nameLabel.text = "\(restaurantRowViewModel?.name ?? "")"
            ratingLabel.text = "Rating: \(String.init(restaurantRowViewModel?.rating ?? 0.0))"
            addressLabel.text = "Address: \(String.init(restaurantRowViewModel?.getAddress() ?? ""))"
        }
    }
    
    var favoriteViewModel : FavoriteViewModel? {
        didSet {
            favoriteViewModel?.objectWillChange.receive(on: DispatchQueue.main).sink { [weak self] in
                let isFavorite = self?.favoriteViewModel?.updatedFav ?? false
                self?.favoriteImage.image = isFavorite ? self?.imageFilledHeart : self?.imageEmptyHeart
                
                let tapGesture = isFavorite ? UITapGestureRecognizer(target:self, action:#selector(self?.removeRestaurantAsFavorite)) : UITapGestureRecognizer(target:self, action:#selector(self?.addRestaurantAsFavorite))
                self?.favoriteImage.isUserInteractionEnabled = true
                self?.favoriteImage.addGestureRecognizer(tapGesture)
                
            }.store(in: &cancellables)
            favoriteViewModel?.checkFav()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(restaurantImage)
        contentView.addSubview(favoriteImage)
        
        let stackViewInfo = UIStackView.createStackView(views: [nameLabel, ratingLabel, addressLabel], alignment: UIStackView.Alignment.leading)
        contentView.addSubview(stackViewInfo)
        
        restaurantImage.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: stackViewInfo.bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 15, paddingBottom: 5, paddingRight: 15, width: 120, height: 0, enableInsets: false)
        
        stackViewInfo.anchor(top: contentView.topAnchor, left: restaurantImage.rightAnchor, bottom: contentView.bottomAnchor, right: nil, paddingTop: 15, paddingLeft: 20, paddingBottom: 15, paddingRight: 20, width: 0, height: 0, enableInsets: false)
        favoriteImage.anchor(top: contentView.topAnchor, left: stackViewInfo.rightAnchor, bottom: stackViewInfo.bottomAnchor, right: contentView.rightAnchor, paddingTop: 15, paddingLeft: 20, paddingBottom: 15, paddingRight: 20, width: 30, height: 0, enableInsets: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func addRestaurantAsFavorite() {
        print("add resto")
        favoriteViewModel?.addResto()
    }
    
    @objc func removeRestaurantAsFavorite() {
        print("remove resto")
        favoriteViewModel?.deleteResto()
    }
    
}
