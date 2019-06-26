//
//  Recipe.swift
//  TestRecipes
//
//  Created by Tymofii Hazhyi on 6/25/19.
//  Copyright © 2019 Tymofii Hazhyi. All rights reserved.
//

import Foundation

enum Complexity: String, CaseIterable {
    case easy
    case medium
    case hard
}

enum CookingTime: String, CaseIterable {
    case less10
    case less20
    case more20
    
    var title: String {
        switch self {
        case .less10:
            return "0-10 min"
        case .less20:
            return "10-20 min"
        case .more20:
            return "20+ min"
        }
    }
}

struct Recipe: Codable {
    let name: String
    let ingredients: [Ingredient]
    let steps: [String]
    let timers: [Int]
    let imageURL: String?
    let originalURL: String?
}

struct Ingredient: Codable {
    let quantity: String
    let name: String
    let type: String
}

extension Recipe {
    var complexity: Complexity {
        let complexAmount = ingredients.count + steps.count
        switch complexAmount {
        case 0...10:
            return .easy
        case 11...20:
            return .medium
        default:
            return .hard
        }
    }
    
    var cookingTime: CookingTime {
        let time = timers.reduce(0, +)
        switch time {
        case 0...10:
            return .less10
        case 10...20:
            return .less20
        default:
            return .more20
        }
    }
}
