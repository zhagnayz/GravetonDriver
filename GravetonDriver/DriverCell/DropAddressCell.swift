//
//  DropAddressCell.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 2/26/23.
//

import UIKit

class DropAddressCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "DropAddressCell"
    
    let dropLabel: UILabel = {
        
        let dropLabel = UILabel()
        dropLabel.textColor = .red
        dropLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        dropLabel.backgroundColor = .orange
        dropLabel.layer.masksToBounds = true
        dropLabel.layer.cornerRadius = 4
        
        
        return dropLabel
    }()
    
    let addressLabel: UILabel = {
        
        let addressLabel = UILabel()
        addressLabel.textColor = .label
        addressLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        addressLabel.numberOfLines = 0
        
        return addressLabel
    }()
    
    let button: UIButton = {
        
        let button = UIButton()
        
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        
        
        return button
    }()
    
    let separator = UIView(frame: .zero)
    override init(frame:CGRect){
        super.init(frame: frame)
        
        separator.backgroundColor = .clear
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        
        let stackViewOne = UIStackView(arrangedSubviews: [dropLabel,separator])
        stackViewOne.distribution = .equalSpacing
        
        let stackViewTwo = UIStackView(arrangedSubviews: [addressLabel,button])
        stackViewTwo.spacing = 10
        
        
        let stackView = UIStackView(arrangedSubviews: [stackViewOne,stackViewTwo])
        stackView.axis = .vertical
        stackView.spacing = 5
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
        
    
            
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
        ])
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
