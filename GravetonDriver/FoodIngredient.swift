//
//  FoodIngredient.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 2/27/23.
//

import Foundation

struct FoodIngredient: Codable,Hashable {
    
    let id: Int
    let section: String
    let title: String
    let subTitle: String
    let buttonTitle: String
    var ingredient:[Ingredient]
}
