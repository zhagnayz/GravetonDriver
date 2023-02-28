//
//  OrderItem.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 2/27/23.
//

import Foundation

struct OrderItem: Codable,Hashable {
    
    let restaurantName: String
    let name: String
    var price: Double
    let details: String
    let image: String
    var quantity: Int = 1
    
    var foodIngredient: [FoodIngredient]
    
    var totalPrice: Double {
        
        return (price*Double(quantity))
    }
    
    var te: Double = 10
    
    var formattedPrice: String {
        
        return String(format: "$%.2f", price)
    }
    
    var formattedQuantity: String {
        
        return String(format: "x %d", quantity)
    }
    
    var formattedTotalPrice: String {
        
        return String(format: "$%.2f", totalPrice)
    }
    
//    init(from menuItem:MenuItem,restaurantName:String,itemIndex index:Int){
//
//        self.restaurantName = restaurantName
//        self.name = menuItem.name
//
//        var tot: Double = 0.0
//
//        for item in menuItem.foodIngredient {
//
//            for ite in item.ingredient {
//
//                if ite.isSelected == true {
//
//                    tot += ite.price
//                }
//            }
//        }
//
//        var chargeVeg: Double = 0.0
//
//        for item in menuItem.foodIngredient {
//
//            for ite in item.ingredient {
//
//                if ite.isChecked == true {
//
//                    chargeVeg += ite.price
//                }
//            }
//        }
//
//        self.price = (menuItem.price + tot + chargeVeg)
//        self.details = menuItem.details
//        self.image = menuItem.image
//        self.quantity = menuItem.quantity
//        self.foodIngredient = menuItem.foodIngredient
//    }
}
