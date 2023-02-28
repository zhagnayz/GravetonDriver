//
//  DropOrPickUpView.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 2/26/23.
//

import UIKit

class DropOrPickUpView: UIView {
    
    let addressLabel: UILabel = {
        
        let addressLabel = UILabel()
        addressLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        addressLabel.textColor = .label
        
        return addressLabel
    }()
    
    let imageView = UIImageView()
    let dollarSignImage = UIImageView()
    
    
    let dateLabel: UILabel = {
        
        let dateLabel = UILabel()
        dateLabel.textColor = .gray
        
        
        return dateLabel
    }()
    
    let CashLabel: UILabel = {
        
        let dateLabel = UILabel()
        dateLabel.textColor = .gray
        
        
        return dateLabel
    }()
    
    let dropButton: UIButton = {
        
        let dropButton = UIButton()
        dropButton.layer.cornerRadius = 4
        
        return dropButton
    }()
    
    override init(frame:CGRect){
        super.init(frame: frame)
        
        imageView.image = UIImage().withTintColor(.gray, renderingMode: .alwaysOriginal)
        
        dollarSignImage.image = UIImage().withTintColor(.gray, renderingMode: .alwaysOriginal)
        
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        
        let stackViewOne = UIStackView(arrangedSubviews: [addressLabel,dropButton])
        stackViewOne.spacing = 10
        
        
        let stackViewTwo = UIStackView(arrangedSubviews: [imageView,dateLabel])
        stackViewTwo.distribution = .fill
        stackViewTwo.spacing = 5
        
        let stackViewThree = UIStackView(arrangedSubviews: [dollarSignImage,CashLabel])
        stackViewThree .distribution = .fill
        stackViewThree .spacing = 5
        
        let stackView = UIStackView(arrangedSubviews: [stackViewOne,stackViewTwo,stackViewThree])
        stackView.axis = .vertical
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 5),
            stackView.topAnchor.constraint(equalTo: topAnchor,constant: 5),
            stackView.bottomAnchor.constraint(equalTo:bottomAnchor,constant: -5),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -5),
            
            imageView.heightAnchor.constraint(equalToConstant: 20),
            imageView.widthAnchor.constraint(equalToConstant: 20),
            dollarSignImage.heightAnchor.constraint(equalToConstant: 20),
            dollarSignImage.widthAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
