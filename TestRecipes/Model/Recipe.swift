//
//  Recipe.swift
//  TestRecipes
//
//  Created by Tymofii Hazhyi on 6/25/19.
//  Copyright © 2019 Tymofii Hazhyi. All rights reserved.
//

import Foundation

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
