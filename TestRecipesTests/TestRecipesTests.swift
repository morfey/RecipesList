//
//  TestRecipesTests.swift
//  TestRecipesTests
//
//  Created by Tymofii Hazhyi on 6/25/19.
//  Copyright © 2019 Tymofii Hazhyi. All rights reserved.
//

import XCTest
@testable import TestRecipes

class TestRecipesTests: XCTestCase {
    var network = NetworkService()
    var store = DataStore()
    
    let testRecipe = Recipe(name: "Test Recipe",
                            ingredients: [Ingredient(quantity: "1", name: "test ingridient", type: "test type")],
                            steps: ["Test step 1"],
                            timers: [],
                            imageURL: nil,
                            originalURL: nil)
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testListRecipesApiEnpointRequest() {
        network.getRecipesList { items, error in
            XCTAssertNotNil(items)
        }
    }
    
    func testListRecipesApiEncode() {
        network.getRecipesList { items, error in
            let item = items?.first
            XCTAssertNotNil(item)
        }
    }
    
    func testBasicNavigationFlow() {
        Main().startProgram()
        XCTAssert((appDelegate.window?.rootViewController as? UINavigationController)?.topViewController is ListRecipesViewController)
    }
    
    func testCustomNavigationFlow() {
        Main().startProgram(.details({_ in }))
        XCTAssertFalse((appDelegate.window?.rootViewController as? UINavigationController)?.topViewController is ListRecipesViewController)
    }
    
    func testCacheResponse() {
        store.items = []
        if let recipes = cache.retriveRecipes(), !recipes.isEmpty {
            XCTAssertFalse(store.items.isEmpty)
        } else {
            XCTAssert(store.items.isEmpty)
        }
    }
    
    func testDetailsConfiguration() {
        Main().startProgram(.details { $0.recipe = self.testRecipe })
        let vc = appDelegate.window?.rootViewController as? DetailsViewController
        XCTAssert(vc?.recipe?.name == "Test Recipe")
    }
    
    func testConfigurationBasicCell() {
        let vm = BaseTableCellViewModel(text: "Ingridient 1")
        let cell = BasicTableCell()
        cell.configureCell(vm: vm)
        XCTAssert(cell.textLabel?.text == "Ingridient 1")
    }
    
    func testCellFactoryIdentifier() {
        let vm = BaseTableCellViewModel(text: "Ingridient 1")
        let factory = TableViewCellHelper.factory(for: .baseCell(vm))
        XCTAssert(factory.cell().name() == "BasicTableCell")
    }
    
    func testCellFactoryTitle() {
        let vm = BaseTableCellViewModel(text: "Ingridient 1")
        let factory = TableViewCellHelper.factory(for: .baseCell(vm))
        let cell: TableViewCellProtocol = factory.cell()
        cell.configureCell(vm: factory.vm)
        XCTAssert((cell as? UITableViewCell)?.textLabel?.text == "Ingridient 1")
    }
    
    func testSimpleSelectionCells() {
        Main().startProgram()
        let cookingTime = CookingTime.allCases.map { $0.title }
        appDelegate.window?.rootViewController?.present(ViewControllers.simpleSelect {
            $0.cells = cookingTime
        }.nav, animated: true, completion: nil)
        XCTAssert((((appDelegate.window?.rootViewController as? UINavigationController)?.presentedViewController as? UINavigationController)?.topViewController as? SimpleSelectViewController)?.cells == cookingTime)
    }
    
    func testDetailsRecipe() {
        Main().startProgram(.details { [weak self] in $0.recipe = self?.testRecipe })
        let vc = appDelegate.window?.rootViewController as? DetailsViewController
        let numberOfStepsRow = vc?.tableView.numberOfRows(inSection: 2) ?? 0
        let numberOfIngridientsRows = vc?.tableView.numberOfRows(inSection: 1) ?? 0
        XCTAssert(numberOfStepsRow == testRecipe.steps.count)
        XCTAssert(numberOfIngridientsRows == testRecipe.ingredients.count)
    }
    
    func testErrorViewAppear() {
        let vc = UIStoryboard(name: .list).instantiateVC()
        vc.view.showErrorView("Test Error", action: nil)
        XCTAssert(vc.view.viewWithTag(ErrorMessageView.viewTag) != nil)
    }
    
    func testErrorViewRemove() {
        let vc = UIStoryboard(name: .list).instantiateVC()
        vc.view.showErrorView("Test Error", action: nil)
        vc.view.removeErrorView()
        XCTAssert(vc.view.viewWithTag(ErrorMessageView.viewTag) == nil)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
