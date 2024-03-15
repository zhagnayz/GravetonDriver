//
//  PriceDetailsCell.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 2/27/23.
//

import UIKit

class PriceDetailsCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "PriceDetailsCell"
    
    let priceDetailsLabelStr: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = UIFont.systemFont(ofSize: 16,weight: .semibold)
        return label
    }()

    let grandTotalLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        return label
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
                
        let stackView = UIStackView(arrangedSubviews: [priceDetailsLabelStr,grandTotalLabel])
        stackView.distribution = .equalSpacing

        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 5),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 8),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -5),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -8),
        ])
    }
    
    func configurePricceDetail(_ order: Order?){
                
        priceDetailsLabelStr.text = "Total"
        grandTotalLabel.text = order?.formattedGrandTotal
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
