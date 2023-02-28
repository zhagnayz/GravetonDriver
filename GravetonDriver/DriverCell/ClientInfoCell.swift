//
//  ClientInfoCell.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 2/26/23.
//

import UIKit
import MapKit

class ClientInfoCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "ClientInfoCell"
    
    let mapView: MKMapView = {
        
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    let BoxLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.textAlignment = .center
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.layer.masksToBounds = true
        dateLabel.layer.cornerRadius = 3
        dateLabel.backgroundColor = .tertiaryLabel
        return dateLabel
    }()
    
    
    let emailImageView: UIImageView = {
        
        let image = UIImageView()
        return image
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16,weight: .semibold)
        label.textColor = .gray
        return label
    }()
    
    let phonelImageView: UIImageView = {
        
        let image = UIImageView()
        return image
    }()
    
    let phoneLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16,weight: .semibold)
        label.textColor = .gray
        return label
    }()
    
    let addressImageView: UIImageView = {
        
        let image = UIImageView()
        return image
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16,weight: .semibold)
        return label
    }()

    let dateImageView: UIImageView = {
        
        let image = UIImageView()
        return image
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16,weight: .semibold)
        label.textColor = .gray
        return label
    }()
    
    let lineView: UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        
        return view
    }()
    
    override init(frame:CGRect){
        super.init(frame: frame)
        
        let stackViewOne = UIStackView(arrangedSubviews: [BoxLabel,lineView])
        let stackViewTwo = UIStackView(arrangedSubviews: [emailImageView,emailLabel])
        let stackViewThree = UIStackView(arrangedSubviews: [phonelImageView,phoneLabel])
        
        let stackViewFour = UIStackView(arrangedSubviews: [stackViewTwo,stackViewThree])
        stackViewFour.distribution = .equalSpacing
        
        let stackViewFive = UIStackView(arrangedSubviews: [addressImageView,addressLabel])
        
        let stackViewSix = UIStackView(arrangedSubviews: [dateImageView,dateLabel])

        let stackViewSeven = UIStackView(arrangedSubviews: [stackViewOne,stackViewFour,stackViewFive,stackViewSix])
        stackViewSeven.axis = .vertical
        stackViewSeven.spacing = 15
    
        let stackView = UIStackView(arrangedSubviews: [mapView,stackViewSeven])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([

            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            mapView.heightAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    
    func configureCell(){
        
        emailImageView.image = UIImage(systemName: "envelope.fill")
        phonelImageView.image = UIImage(systemName: "phone.fill")
        addressImageView.image = UIImage(systemName: "mappin.and.ellipse")
        dateImageView.image = UIImage(systemName: "calendar")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
