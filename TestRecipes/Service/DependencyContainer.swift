//
//  DependencyContainer.swift
//  TestRecipes
//
//  Created by Tymofii Hazhyi on 7/30/19.
//  Copyright © 2019 Tymofii Hazhyi. All rights reserved.
//

import Foundation

class DependencyContainer { }

protocol ViewControllerFactory {
    func makeListRecipesViewController() -> ListRecipesViewController
    func makeDetailsRecipeViewController(recipe: Recipe) -> DetailsViewController
    func makeSimpleSelectViewController(configuration: SimpleSelectConfiguration) -> SimpleSelectViewController
}

extension DependencyContainer: ViewControllerFactory {
    func makeListRecipesViewController() -> ListRecipesViewController {
        return ListRecipesViewController(factory: self)
    }
    
    func makeDetailsRecipeViewController(recipe: Recipe) -> DetailsViewController {
        return DetailsViewController(recipe: recipe)
    }
    
    func makeSimpleSelectViewController(configuration: SimpleSelectConfiguration) -> SimpleSelectViewController {
        return SimpleSelectViewController(configuration: configuration)
    }
}

protocol NetworkServiceFactory {
    func makeNetworkService() -> NetworkService
}

protocol DataSouceFactory {
    func makeDataSource() -> DataSource
}

extension DependencyContainer: NetworkServiceFactory {
    func makeNetworkService() -> NetworkService {
        return NetworkService()
    }
}

extension DependencyContainer: DataSouceFactory {
    func makeDataSource() -> DataSource {
        return DataSource()
    }
}
