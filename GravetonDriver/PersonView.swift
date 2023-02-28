//
//  PersonView.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 2/26/23.
//

import UIKit

class personView: UIView {
    
    let personLabel: UILabel = {
        
        let personLabel = UILabel()
        personLabel.textColor = .label
        personLabel.font = UIFont.systemFont(ofSize: 18,weight: .semibold)
        
        
        return personLabel
    }()
    
    let nameLabel: UILabel = {
        
        let personLabel = UILabel()
        personLabel.textColor = .label
        personLabel.font = UIFont.systemFont(ofSize: 16,weight: .semibold)
        
        
        return personLabel
    }()
    
    let nameTextField: UITextField = {
        
        let nameTextField = UITextField()
        nameTextField.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        nameTextField.backgroundColor = .tertiarySystemGroupedBackground
        nameTextField.layer.cornerRadius = 5
        
        return nameTextField
    }()
    
    let phoneLabel: UILabel = {
        
        let personLabel = UILabel()
        personLabel.textColor = .label
        personLabel.font = UIFont.systemFont(ofSize: 16,weight: .semibold)
        
        return personLabel
    }()
    
    let phoneTextField: UITextField = {
        
        let nameTextField = UITextField()
        nameTextField.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        nameTextField.backgroundColor = .tertiarySystemGroupedBackground
        nameTextField.layer.cornerRadius = 5
        
        return nameTextField
    }()
    
    override init(frame:CGRect){
        super.init(frame: frame)
        
        
        let stackViewOne = UIStackView(arrangedSubviews: [personLabel,nameLabel,nameTextField])
        stackViewOne.axis = .vertical
        
        let stackViewTwo = UIStackView(arrangedSubviews: [phoneLabel,phoneTextField])
        stackViewTwo.axis = .vertical
        
        let stackView = UIStackView(arrangedSubviews: [stackViewOne,stackViewTwo])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
