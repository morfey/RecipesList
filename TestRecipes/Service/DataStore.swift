//
//  DataStore.swift
//  TestRecipes
//
//  Created by Tymofii Hazhyi on 6/25/19.
//  Copyright © 2019 Tymofii Hazhyi. All rights reserved.
//

import Foundation

class DataStore {
    private var isSearching = false
    private var original = [Recipe]()
    static let shared = DataStore()
    
    var complexityFilter: Complexity = .any
    var cookingTime: CookingTime = .any
    
    var items = [Recipe]() {
        didSet {
            (items.isEmpty && !isSearching) ? items = cache.retriveRecipes() ?? [] : cache.storeRecipes()
            if !isSearching { original = items }
        }
    }
    
    init() {}
    
    func filter(with text: String?) {
        isSearching = true
        if let request = text?.lowercased() {
            items = original.filter {
                $0.name.contains(request) ||
                    !$0.ingredients.map { $0.name }.filter { $0.contains(request) }.isEmpty ||
                    !$0.steps.filter { $0.contains(request) }.isEmpty
            }
        } else {
            items = original
        }
        items = items.filter {
            (complexityFilter != .any ? $0.complexity == complexityFilter : true) &&
            (cookingTime != .any ? $0.cookingTime == cookingTime : true)
        }
        isSearching = false
    }
}
