//
//  CustomProfile.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 2/26/23.
//

import UIKit

class CustomProfile: UIControl {

    let userNameLabel: UILabel = {
        
        let userNameLabel = UILabel()
        userNameLabel.font = UIFont.systemFont(ofSize: 16)
        userNameLabel.textColor = .label
        
        return userNameLabel
    }()
    
    let userEmailLabel: UILabel = {
        
        let userEmailLabel = UILabel()
        userEmailLabel.font = UIFont.systemFont(ofSize: 14)
        userEmailLabel.textColor = .label
        
        return userEmailLabel
    }()
    
    let userFirstLetterNameLabel: UIButton = {
        
        let serFirstLetterNameLabel = UIButton()
        serFirstLetterNameLabel.titleLabel?.font = UIFont.systemFont(ofSize: 80,weight: .bold)
        serFirstLetterNameLabel.setTitleColor(.label, for: .normal)
        serFirstLetterNameLabel.backgroundColor = .tertiarySystemGroupedBackground
        
        return serFirstLetterNameLabel
    }()
    
    
    override init(frame:CGRect){
        super.init(frame: frame)
        
        
        let stackViewOne = UIStackView(arrangedSubviews: [userNameLabel,userEmailLabel])
        stackViewOne.axis = .vertical
        stackViewOne.distribution = .fillProportionally
        
        let stackView = UIStackView(arrangedSubviews: [userFirstLetterNameLabel,stackViewOne])
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
        
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            //stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


