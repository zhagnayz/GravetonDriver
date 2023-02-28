//
//  TaskDetailsCell.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 2/27/23.
//

import UIKit

class TaskDetailsCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "TaskDetailsCell"
    
    var taskDetailLabel:  UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .gray
        return label
    }()
    
    var name:  UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
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
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16,weight: .semibold)
        return label
    }()
    
    let taskLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16,weight: .semibold)
        return label
    }()
    
    let restLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16,weight: .semibold)
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

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stackViewOne = UIStackView(arrangedSubviews: [taskDetailLabel])
        let stackViewTwo = UIStackView(arrangedSubviews: [emailImageView,emailLabel])
        let stackViewThree = UIStackView(arrangedSubviews: [phonelImageView,phoneLabel])
        
        let stackViewFour = UIStackView(arrangedSubviews: [stackViewTwo,stackViewThree])
        stackViewFour.distribution = .equalSpacing
        
        let stackViewFive = UIStackView(arrangedSubviews: [dateLabel,taskLabel,restLabel])
        stackViewFive.axis = .vertical
        stackViewFive.spacing = 10
        
        let stackView = UIStackView(arrangedSubviews: [stackViewOne,stackViewFour,stackViewFive])
        stackView.axis = .vertical
        stackView.spacing = 15
        
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
