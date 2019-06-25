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
    
    let storage: Storage<[Recipe]>
    
    init() {
        let diskConfig = DiskConfig(name: "RecipesCache")
        let memoryConfig = MemoryConfig(expiry: .date(Date().addingTimeInterval(60)), countLimit: 10, totalCostLimit: 10)
        
        do {
            storage = try Storage(
                diskConfig: diskConfig,
                memoryConfig: memoryConfig,
                transformer: TransformerFactory.forCodable(ofType: [Recipe].self)
            )
        } catch {
            fatalError("Cache cannot be implemented")
        }
    }
    
    func retriveRecipes() -> [Recipe]? {
        return try? storage.object(forKey: "items")
    }
    
    func storeRecipes() {
        try? cache.storage.setObject(store.items, forKey: "items")
    }
}
