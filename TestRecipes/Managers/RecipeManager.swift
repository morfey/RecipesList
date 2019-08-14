//
//  RecipeManager.swift
//  TestRecipes
//
//  Created by Tymofii Hazhyi on 8/7/19.
//  Copyright © 2019 Tymofii Hazhyi. All rights reserved.
//

import Foundation

class RecipeManager {
    private(set) var networkService: NetworkServiceProtocol
    private var dataSource: DataSource
    
    init(networkService: NetworkServiceProtocol, dataSource: DataSource) {
        self.networkService = networkService
        self.dataSource = dataSource
    }
    
    var complexityFilter: Complexity {
        get { return dataSource.complexityFilter }
        set { dataSource.complexityFilter = newValue }
    }
    
    var cookingTime: CookingTime {
        get { return dataSource.cookingTime }
        set { dataSource.cookingTime = newValue }
    }
    
    var items: [Recipe] {
        get { return dataSource.items }
        set { dataSource.items = newValue }
    }
}

extension RecipeManager {
    func getRecipesList(completion: @escaping (Result<[Recipe], Error>) -> ()) {
        networkService.request(api: .list, completion: completion)
    }
    
    func filter(with string: String?) {
        dataSource.filter(with: string)
    }
}
