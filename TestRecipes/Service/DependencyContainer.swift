//
//  DependencyContainer.swift
//  TestRecipes
//
//  Created by Tymofii Hazhyi on 7/30/19.
//  Copyright © 2019 Tymofii Hazhyi. All rights reserved.
//

import Foundation
import UIKit

class DependencyContainer { }

protocol ViewControllerFactory {
    func makeListRecipesViewController() -> ListRecipesViewController
    func makeDetailsRecipeViewController(recipe: Recipe) -> DetailsViewController
    func makeCookingTimeFilterViewController(selectClosure: ((Int) -> ())?, selectedIndex: Int?) -> UIViewController
    func makeComplexityFilterViewController(selectClosure: ((Int) -> ())?, selectedIndex: Int?) -> UIViewController
}

extension DependencyContainer: ViewControllerFactory {
    func makeListRecipesViewController() -> ListRecipesViewController {
        return ListRecipesViewController(factory: self)
    }
    
    func makeDetailsRecipeViewController(recipe: Recipe) -> DetailsViewController {
        return DetailsViewController(recipe: recipe)
    }
    
    func makeCookingTimeFilterViewController(selectClosure: ((Int) -> ())?, selectedIndex: Int?) -> UIViewController {
        let cookingTime = CookingTime.allCases
        let configuration = SimpleSelectConfiguration()
        configuration.cells = cookingTime.map { $0.title }
        configuration.closureDidSelectCell = selectClosure
        configuration.selectedCell = selectedIndex
        let vc = makeSimpleSelectViewController(configuration: configuration)
        let nav = UINavigationController(rootViewController: vc)
        return nav
    }
    
    func makeComplexityFilterViewController(selectClosure: ((Int) -> ())?, selectedIndex: Int?) -> UIViewController {
        let complexity = Complexity.allCases
        let configuration = SimpleSelectConfiguration()
        configuration.cells = complexity.map { $0.rawValue.capitalized }
        configuration.closureDidSelectCell = selectClosure
        configuration.selectedCell = selectedIndex
        let vc = makeSimpleSelectViewController(configuration: configuration)
        let nav = UINavigationController(rootViewController: vc)
        return nav
    }
    
    func makeSimpleSelectViewController(configuration: SimpleSelectConfiguration) -> SimpleSelectViewController {
        return SimpleSelectViewController(configuration: configuration)
    }
}

protocol RecipeManagerFactory {
    func makeRecipeManager() -> RecipeManager
}

protocol DataSouceFactory {
    func makeDataSource() -> DataSource
}

extension DependencyContainer: RecipeManagerFactory {
    func makeRecipeManager() -> RecipeManager {
        return RecipeManager(networkService: NetworkService())
    }
}

extension DependencyContainer: DataSouceFactory {
    func makeDataSource() -> DataSource {
        return DataSource()
    }
}
