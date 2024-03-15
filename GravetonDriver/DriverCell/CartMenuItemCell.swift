//
//  CartMenuItemCell.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 2/27/23.
//

import UIKit

class CartMenuItemCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "CartMenuItemCell"
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18,weight: .semibold)
        return label
    }()
    
    let proteinLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16,weight: .semibold)
        label.textColor = .red
        return label
    }()
    
    enum Sections: Int {
        case sectionOne
    }
    
    var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Sections,AnyHashable>?
    
    let testingLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 4
        contentView.backgroundColor = .tertiarySystemGroupedBackground
        
        let stackViewOne = UIStackView(arrangedSubviews: [proteinLabel,detailLabel])
        stackViewOne.axis = .vertical
        
        let stackViewThree = UIStackView(arrangedSubviews: [stackViewOne,testingLabel])
        stackViewThree.axis = .vertical
        stackViewThree.spacing = 10
        
        let stackViewTwo = UIStackView(arrangedSubviews: [nameLabel,priceLabel])
        stackViewTwo.distribution = .equalSpacing
        
        let stackView = UIStackView(arrangedSubviews: [stackViewTwo,stackViewThree])
        stackView.axis = .vertical
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    func configureCell(_ orderItem:OrderItem?){
        
        guard let orderItem = orderItem else {return}
        
        nameLabel.text = orderItem.name
        
        if let proteins = orderItem.protein {
            
            for pro in  proteins{
                proteinLabel.text =  pro
            }
        }
 
        detailLabel.text = orderItem.spiceLevel
        priceLabel.text = orderItem.formattedSubTotal
        
        if let addItems = orderItem.addItems{
           
            var t:String = ""
            for addItem in addItems{
                
                t += "- \(addItem)\n"
            }
            testingLabel.text = t
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

