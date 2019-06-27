//
//  Cache.swift
//  TestRecipes
//
//  Created by Tymofii Hazhyi on 6/25/19.
//  Copyright © 2019 Tymofii Hazhyi. All rights reserved.
//

import Foundation
import Cache

final class Cache {
    static let shared = Cache()
    typealias T = [Recipe]
    let storage: Storage<T>
    
    init() {
        let diskConfig = DiskConfig(name: "RecipesCache")
        let memoryConfig = MemoryConfig(expiry: .date(Date().addingTimeInterval(60)), countLimit: 10, totalCostLimit: 10)
        
        do {
            storage = try Storage(
                diskConfig: diskConfig,
                memoryConfig: memoryConfig,
                transformer: TransformerFactory.forCodable(ofType: T.self)
            )
        } catch {
            fatalError("Cache cannot be implemented")
        }
    }
    
    func retriveRecipes() -> T? {
        return try? storage.object(forKey: "items")
    }
    
    func store(_ recipes: T) {
        try? cache.storage.setObject(recipes, forKey: "items")
    }
}
