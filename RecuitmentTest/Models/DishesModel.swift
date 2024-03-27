//
//  DishesModel.swift
//  RecuitmentTest
//
//  Created by Nam Nguyễn on 28/03/2024.
//

import Foundation

// MARK: - Dishes
struct Dishes: Codable {
    var dishes: [Dish]?
}

// MARK: - Dish
struct Dish: Codable {
    var id: Int?
    var name, restaurant: String?
    var availableMeals: [String]?
}

struct OrderDishModel {
    var name: String
    var number: Int
    
    init(name: String = "", number: Int = 0) {
        self.name = name
        self.number = number
    }
    
    mutating func updateName(name: String) {
        self.name = name
    }
    
    mutating func updateNumber(number: Int) {
        self.number = number
    }
}
