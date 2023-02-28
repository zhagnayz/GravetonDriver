//
//  DropCell.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 2/26/23.
//

import UIKit

class DropCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "DropCell"
    
    let addressLabel: UILabel = {
        let addressLabel = UILabel()
        addressLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return addressLabel
    }()
    
    let imageView: UIImageView = {
        
        let image = UIImageView()
    
        return image
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        return label
    }()
    
    let BoxLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.textAlignment = .center
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.layer.masksToBounds = true
        dateLabel.layer.cornerRadius = 3
        return dateLabel
    }()
    
    var lineView: UIView = {
        
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    override init(frame:CGRect){
        super.init(frame: frame)
      
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.borderWidth = 0.8
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 6
        
        let stackViewOne = UIStackView(arrangedSubviews: [addressLabel,BoxLabel])
        stackViewOne.distribution = .equalSpacing
        stackViewOne.alignment = .center
        
        let stackViewTwo = UIStackView(arrangedSubviews: [imageView,dateLabel,lineView])
        stackViewTwo.alignment = .center
        stackViewTwo.distribution = .fill
        
        let stackView = UIStackView(arrangedSubviews: [stackViewOne,stackViewTwo])
        stackView.axis = .vertical

        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
        
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 5),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 5),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -5),
           // stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -5),
            BoxLabel.widthAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    func configureCell(_ testing: [Testing],indexPath:IndexPath){
        
        addressLabel.text = testing[indexPath.item].title
        dateLabel.text = testing[indexPath.item].date
        imageView.image = testing[indexPath.item].image
        BoxLabel.text = testing[indexPath.item].pickUpOrDrop
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
