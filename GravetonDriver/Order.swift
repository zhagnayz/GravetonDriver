//
//  Order.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 2/27/23.
//

import Foundation

struct Order:Codable, Hashable {
    
    let reference: String
    let title: String
    var date: String
    
    let items: [OrderItem]
    
    var couponIncluded: Bool
    
    var subTotal: Double {
        
        return items.reduce(0, {$0 + $1.totalPrice})
    }
    
    var formattedSubTotal: String {
        
        return String(format: "$%.2f", subTotal)
    }
    
    let deliveryCharge: Double
    
    var formattedDeliveryCharge: String {
        
        return String(format: "$%.2f", deliveryCharge)
    }
    
    let tip: Double
    
    var formattedTip: String {
        
        return String(format: "$%.2f", tip)
    }
    
    var tax: Double{
        
        return (subTotal*0.0875)
    }
    
    var formattedTax: String {
        
        return String(format: "$%.2f", tax)
    }
    
    var grandTotal: Double {
        
        return subTotal + tax + deliveryCharge + tip
    }
    
    var formattedGrandTotal: String {
        
        return String(format: "$%.2f", grandTotal)
    }
    
    init(reference:String?,title:String?,date:String?,deliveryCharge:Double,tip:Double,items:[OrderItem],couponIncluded: Bool = false){
        
        if let orderRef = reference {
            
            self.reference = orderRef
        }else{
            
            self.reference = Order.generateOrderNumber()
        }
        
        if let orderTitle = title {
            
            self.title = orderTitle
        }else{
            
            self.title = "No Title"
        }
        
        if let orderDate = date {
            
            self.date = orderDate
        }else{
            
            let dateFormatter = DateFormatter()
            
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.setLocalizedDateFormatFromTemplate("MM-dd-yyyy HH:mm")
            
            self.date = dateFormatter.string(from: Date())
        }
        
        self.deliveryCharge = deliveryCharge
        self.tip = tip
        self.items = items
        self.couponIncluded = couponIncluded
        
    }
    
//    init?(cart:Cart,deliveryCharge:Double){
//
//        guard cart.items.count > 0 else {return nil}
//
//        self.init(reference: nil, title: cart.title, date: nil, deliveryCharge: deliveryCharge, tip: cart.tip, items: cart.items,couponIncluded: cart.couponIncluded)
//    }
    
    static func generateOrderNumber() -> String {

        func transform(_ source: Double) -> Int {

            let a = 89.8
            let b = 39.8
            let c = 83.9

            return Int(((source*b)+a)/c)
        }

        var firstComponent = Double(arc4random())
        firstComponent.formTruncatingRemainder(dividingBy: 1000)

        var secondComponent = Double(arc4random())
        secondComponent.formTruncatingRemainder(dividingBy: 1000)

        return "#\(transform(firstComponent))\(transform(secondComponent))"
    }
}
