//
//  TaskHistoryCell.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 2/26/23.
//

import UIKit

class TaskHistoryCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "TaskHistoryCell"
    
    let cashToCollectLabel: UILabel = {
        
        let cashToCollectLabel = UILabel()
        cashToCollectLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        cashToCollectLabel.textColor = .label
        
        return cashToCollectLabel
    }()
    
    let SelectDatetLabel: UILabel = {
        
        let cashToCollectLabel = UILabel()
        cashToCollectLabel.font = UIFont.systemFont(ofSize: 10)
        cashToCollectLabel.textColor = .gray
        cashToCollectLabel.text = "Select A Date"
        
        return cashToCollectLabel
    }()
    
    let clearButton: UIButton = {
        
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        button.setTitle("clear", for: .normal)
        
        
        return button
    }()
    
    let imageIcon = UIImageView()
    
    let taskView = DropOrPickUpView()
    
    override init(frame:CGRect){
        super.init(frame: frame)
        
        imageIcon.image = UIImage(systemName: "calendar")
        
        let stackViewOne = UIStackView(arrangedSubviews: [cashToCollectLabel,clearButton,SelectDatetLabel,imageIcon])
        stackViewOne.spacing = 5
        
        let stackView = UIStackView(arrangedSubviews: [stackViewOne,taskView])
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
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
