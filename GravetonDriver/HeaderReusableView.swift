//
//  HeaderReusableView.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 2/26/23.
//

import UIKit

class HeaderReusableView: UICollectionReusableView {
        
    static let reuseIdentifier: String = "HeaderReusableView"
    
    let headerLabel: UILabel = {
        
        let headerLabel = UILabel()
        headerLabel.font = UIFont.systemFont(ofSize: 16,weight: .bold)
        headerLabel.textColor = .label
        headerLabel.textAlignment = .left
        
        return headerLabel
    }()
    
    override init(frame:CGRect){
        super.init(frame: frame)
        
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(headerLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
