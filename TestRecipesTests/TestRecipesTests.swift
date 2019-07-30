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
    var store = DataSource()
    
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
    
    func testCacheResponse() {
        store.items = []
        if let recipes = cache.retriveRecipes(), !recipes.isEmpty {
            XCTAssertFalse(store.items.isEmpty)
        } else {
            XCTAssert(store.items.isEmpty)
        }
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

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
