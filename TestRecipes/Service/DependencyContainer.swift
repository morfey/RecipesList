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
    func makeSimpleSecetionViewController(cells: [String], selectClosure: ((Int) -> ())?, selectedIndex: Int?) -> UIViewController
}

extension DependencyContainer: ViewControllerFactory {
    func makeListRecipesViewController() -> ListRecipesViewController {
        return ListRecipesViewController(factory: self)
    }
    
    func makeDetailsRecipeViewController(recipe: Recipe) -> DetailsViewController {
        return DetailsViewController(recipe: recipe)
    }
    
    func makeSimpleSecetionViewController(cells: [String], selectClosure: ((Int) -> ())?, selectedIndex: Int?) -> UIViewController {
        let configuration = SimpleSelectConfiguration()
        configuration.cells = cells
        configuration.closureDidSelectCell = selectClosure
        configuration.selectedCell = selectedIndex
        let vc = makeSimpleSelectViewController(configuration: configuration)
        let navigationController = UINavigationController(rootViewController: vc)
        return navigationController
    }
    
    func makeSimpleSelectViewController(configuration: SimpleSelectConfiguration) -> SimpleSelectViewController {
        return SimpleSelectViewController(configuration: configuration)
    }
}

protocol RecipeManagerFactory {
    func makeRecipeManager() -> RecipeManager
}

extension DependencyContainer: RecipeManagerFactory {
    func makeRecipeManager() -> RecipeManager {
        return RecipeManager(networkService: NetworkService(), dataSource: DataSource())
    }
}
