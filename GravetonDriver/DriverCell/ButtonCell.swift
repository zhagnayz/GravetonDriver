//
//  ButtonCell.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 2/26/23.
//

import UIKit

class ButtonCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "ButtonCell"
    
    var name:  UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    let subName = UILabel()
    
    let iconImageView = UIImageView()
        
    override init(frame:CGRect){
        super.init(frame: frame)
        
        subName.textColor = .gray
        subName.numberOfLines = 0
        subName.font = UIFont.systemFont(ofSize: 14)
        
        let stackViewOne = UIStackView(arrangedSubviews: [iconImageView,name,subName])
        stackViewOne.alignment = .center
        stackViewOne.spacing = 10
        
        let stackView = UIStackView(arrangedSubviews: [stackViewOne])
        stackView.axis = .vertical
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
        
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 5),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    
    func configureCell(iconMenu: [IconMenu],indexPath: IndexPath){
        
        iconImageView.image = iconMenu[indexPath.item].icon
        name.text = iconMenu[indexPath.item].name
        subName.text = iconMenu[indexPath.item].subName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
