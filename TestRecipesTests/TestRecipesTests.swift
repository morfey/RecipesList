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
        XCTAssert(appDelegate.window?.rootViewController is ListRecipesViewController)
    }
    
    func testCustomNavigationFlow() {
        Main().startProgram(.details)
        XCTAssertFalse(appDelegate.window?.rootViewController is ListRecipesViewController)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
