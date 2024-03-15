//
//  TextFieldCell.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 4/3/23.
//

import UIKit

class TextFieldCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "TextFieldCell"
    
    let textField: CustomTextField = {
        
        let textField = CustomTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholderColor = .black
        textField.isHighlightedOnEdit = true
        textField.highlightedColor = .systemBlue
        
        // Setting up small placeholder
        textField.smallPlaceholderColor = .quaternaryLabel
        textField.smallPlaceholderLeftOffset = 0
        
        textField.placeholderColor = .quaternaryLabel
        
        textField.separatorIsHidden = false
        textField.separatorLineViewColor = textField.smallPlaceholderColor
        textField.separatorLeftPadding = -8
        textField.separatorRightPadding = -8
        textField.font = UIFont.systemFont(ofSize: 18)
        
        return textField
    }()
    
    var placeHolderr: String? {
        
        didSet {
            
            guard let userInfo = placeHolderr else {return}
            textField.smallPlaceholderText = userInfo
            
            textField.placeholder = userInfo
        }
    }
    
    override init(frame:CGRect){
        super.init(frame: frame)

        let stackView = UIStackView(arrangedSubviews: [textField])
        
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
