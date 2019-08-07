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
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
}

extension RecipeManager {
    func getRecipesList(completion: @escaping (Result<[Recipe], Error>) -> ()) {
        networkService.request(api: .list, completion: completion)
    }
}
