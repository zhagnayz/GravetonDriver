//
//  FeaturedCircleProducts.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 2/22/24.
//

import UIKit

class FeaturedCircleProducts: UICollectionViewCell {
    
    static let reuseIdentifier: String = "CircleProductCell"
    
    var outerView: UIView = {
        var view = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize(width: 5, height: 10)
        view.layer.cornerRadius = view.frame.size.width/2
        view.layer.shadowRadius = 10
        view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: 40).cgPath
        return view
    }()
    
    var imageView: UIImageView = {
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        image.layer.cornerRadius = image.frame.size.width/2
        image.layer.masksToBounds = true
        return image
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25,weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        outerView.addSubview(imageView)
        
        let stackView = UIStackView(arrangedSubviews: [outerView,nameLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            outerView.heightAnchor.constraint(equalToConstant: 80),
            outerView.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
