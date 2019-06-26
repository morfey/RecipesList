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
    var network: NetworkService = NetworkService()
    
    let testRecipe = Recipe(name: "Test Recipe",
                            ingredients: [],
                            steps: [],
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
    
    func testCellFactory() {
        let vm = BaseTableCellViewModel(text: "Ingridient 1")
        let factory = TableViewCellHelper.factory(for: .baseCell(vm))
        XCTAssert(factory.cell().name() == "BasicTableCell")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
