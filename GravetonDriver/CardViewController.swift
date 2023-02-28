//
//  CardViewController.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 2/26/23.
//

import UIKit

class CardViewController: UIViewController {
    
    let cardPaymentButton: UIButton = {
        
        let config = UIImage.SymbolConfiguration(pointSize: 30)
        
        let cardPaymentButton = UIButton()
        cardPaymentButton.setImage(UIImage(systemName: "creditcard",withConfiguration: config)?.withTintColor(.gray, renderingMode: .alwaysOriginal), for: .normal)
        cardPaymentButton.setTitle("Card Payment  ", for: .normal)
        cardPaymentButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        cardPaymentButton.backgroundColor = .clear
        cardPaymentButton.setTitleColor(.label, for: .normal)
        
        return cardPaymentButton
    }()
    
    let cashOnDeliveryButton: UIButton = {
        let config = UIImage.SymbolConfiguration(pointSize: 30)
        
        let cardPaymentButton = UIButton()
        cardPaymentButton.setImage(UIImage(systemName: "banknote",withConfiguration: config)?.withTintColor(.gray, renderingMode: .alwaysOriginal), for: .normal)
        cardPaymentButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        cardPaymentButton.setTitle("Cash On Delivery", for: .normal)
        cardPaymentButton.setTitleColor(.label, for: .normal)
        cardPaymentButton.backgroundColor = .clear
        
        return cardPaymentButton
    }()
    
    let cancelButton: UIButton = {
        
        let cardPaymentButton = UIButton()
        cardPaymentButton.setTitle("Cancel", for: .normal)
        cardPaymentButton.backgroundColor = .clear
        cardPaymentButton.setTitleColor(.label, for: .normal)
        cardPaymentButton.backgroundColor = .tertiarySystemGroupedBackground
        
        return cardPaymentButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground

        let stackView = UIStackView(arrangedSubviews: [cardPaymentButton,cashOnDeliveryButton,cancelButton])
        
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: view.topAnchor,constant: 10),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            cancelButton.heightAnchor.constraint(equalToConstant: 80),
        ])
    
    }
}

