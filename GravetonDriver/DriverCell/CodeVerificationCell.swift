//
//  CodeVerificationCell.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 2/26/23.
//

import UIKit

class CodeVerificationCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "CodeVerificationCell"
    
    
    let verificationLabel: UILabel = {
        
        let verificationLabel = UILabel()
        verificationLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        verificationLabel.textColor = .label
        
        return verificationLabel
    }()
    
    let CodeInFoLabel: UILabel = {
        
        let SubTitleLabel = UILabel()
        SubTitleLabel.textColor = .label
        
        return SubTitleLabel
    }()
    
    let phoneNumberLabel: UILabel = {
        
        let SubTitleLabel = UILabel()
        SubTitleLabel.textColor = .label
        
        return SubTitleLabel
    }()
    
    let NotReceivLabel: UILabel = {
        
        let SubTitleLabel = UILabel()
        SubTitleLabel.textColor = .label
        
        return SubTitleLabel
    }()
    
    let SendCodeButton: UIButton = {
        
        let loginButton = UIButton()
        loginButton.backgroundColor = .clear
        loginButton.setTitleColor(.systemBlue, for: .normal)
        
        return loginButton
    }()
        
    let testing = OneTimeCodeField(frame: CGRect(x: 0, y: 0, width: 400, height: 55))
    
    
    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))

    let separato = UIView(frame: .zero)
    override init(frame:CGRect){
        super.init(frame: frame)
                
        let config = UIImage.SymbolConfiguration(pointSize: 50)
        button.setImage(UIImage(systemName: "arrowtriangle.forward.fill",withConfiguration: config), for: .normal)
   
        
        let stackViewOne = UIStackView(arrangedSubviews: [CodeInFoLabel,phoneNumberLabel])
        stackViewOne.spacing = 5
    
        let stackViewTwo = UIStackView(arrangedSubviews: [NotReceivLabel,SendCodeButton])
                
        let stackViewTesting = UIView()
        stackViewTesting.addSubview(testing)
        
        let stackView = UIStackView(arrangedSubviews: [verificationLabel,stackViewOne,stackViewTesting,stackViewTwo,button])
        stackView.axis = .vertical
        
        stackView.spacing = 10
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
        
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        stackView.setCustomSpacing(160, after: stackViewTwo)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
