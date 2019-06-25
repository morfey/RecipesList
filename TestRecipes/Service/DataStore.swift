//
//  DataStore.swift
//  TestRecipes
//
//  Created by Tymofii Hazhyi on 6/25/19.
//  Copyright © 2019 Tymofii Hazhyi. All rights reserved.
//

import Foundation

class DataStore {
    static let shared = DataStore()
    
    var items = [Recipe]() {
        didSet {
            items.isEmpty ? items = cache.retriveRecipes() ?? [] : cache.storeRecipes()
        }
    }
    
    init() {}
}
