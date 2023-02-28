//
//  Ingredient.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 2/27/23.
//

import Foundation

struct Ingredient: Codable,Hashable {
    
    let id: Int
    let name: String
    var quantity: Int
    let price: Double
    
    var isSelected: Bool
    var isChecked: Bool
    
    var totalPrice: Double {
        
        return (price*Double(quantity))
    }
    
    var formattedSubTotal: String {
        
        return String(format: "$%.2f", totalPrice)
    }
    var formattedPrice: String {
        
        return String(format: "$%.2f", price)
    }
}
