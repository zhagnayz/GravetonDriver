//
//  CartMenuItemCell.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 2/27/23.
//

import UIKit

class CartMenuItemCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "CartMenuItemCell"
    
    let imageView: UIImageView = {
        
        let image = UIImageView()
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 5
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    let nameLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16,weight: .semibold)
        
        return label
    }()
    
    let proteinLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    let priceDetailLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    let priceLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14,weight: .semibold)
        
        return label
    }()
    
    let detailTitleLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14,weight: .semibold)
        label.textColor = .gray
        
        return label
    }()
    
    let detailLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        
        return label
    }()
    
    let longLineView: UIView = {
        
        let view = UIView()
        view.backgroundColor = .quaternaryLabel
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 4
        contentView.backgroundColor = .tertiarySystemGroupedBackground
        
        let stackViewOne = UIStackView(arrangedSubviews: [priceDetailLabel,priceLabel])
        stackViewOne.spacing = -2
        
        let stackViewTwo = UIStackView(arrangedSubviews: [nameLabel,proteinLabel,stackViewOne,detailTitleLabel,detailLabel])
        stackViewTwo.axis = .vertical
   
        let stackViewFour = UIStackView(arrangedSubviews: [imageView,stackViewTwo])
        stackViewFour.spacing = 5
        
        let stackViewSix = UIStackView(arrangedSubviews: [stackViewFour])
        
        let stackView = UIStackView(arrangedSubviews: [longLineView,stackViewSix])
        stackView.axis = .vertical
        stackView.spacing = 3
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 140),
            longLineView.heightAnchor.constraint(equalToConstant: 1),
        ])
        
    }
    
    func configureCell(){
   
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

