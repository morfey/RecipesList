//
//  RecipeManagersTests.swift
//  TestRecipesTests
//
//  Created by Tymofii Hazhyi on 8/12/19.
//  Copyright © 2019 Tymofii Hazhyi. All rights reserved.
//

import XCTest
@testable import TestRecipes

class NetworkServiceMock: NetworkServiceProtocol {
    var error: Error?
    var collectionResult: [Recipe]?
    
    func request<T: Codable>(api: RecipesApi, completion: @escaping (Result<[T], Error>) -> ()) {
        if let error = error {
            completion(.failure(error))
        } else if let collectionResult = collectionResult {
            completion(.success(collectionResult as! [T]))
        }
    }
}

class RecipeManagersTests: XCTestCase {
    var recipeManager: RecipeManager!
    var networkService: NetworkServiceMock!
    
    let testRecipe = Recipe(name: "Test Recipe",
                            ingredients: [Ingredient(quantity: "1", name: "test ingridient", type: "test type")],
                            steps: ["Test step 1"],
                            timers: [],
                            imageURL: nil,
                            originalURL: nil)
    
    override func setUp() {
        super.setUp()
        networkService = NetworkServiceMock()
        recipeManager = RecipeManager(networkService: networkService)
    }
    
    override func tearDown() {
        recipeManager = nil
        networkService = nil
        super.tearDown()
    }
    
    func testListIsSuccessIfBackendRepliesWithObjects() {
        let collection = [testRecipe]
        networkService.collectionResult = collection
        networkService.error = nil
        
        let expectation = self.expectation(description: "successfull list expectation")
        recipeManager.getRecipesList { result in
            switch result {
            case .failure(_):
                XCTFail("unexpected result")
            case .success(_):
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testListFailsIfBackendReplyWithError() {
        let error = NetworkError.failed
        networkService.error = error
        
        let expectation = self.expectation(description: "successfull error propagation")
        recipeManager.getRecipesList { result in
            switch result {
            case .failure(_):
                expectation.fulfill()
            case .success(_):
                XCTFail("unexpected result")
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testListContainsCorrectNumberOfResults() {
        let collection = [testRecipe]
        networkService.collectionResult = collection
        networkService.error = nil
        
        let expectation = self.expectation(description: "successfull list expectation")
        recipeManager.getRecipesList { result in
            switch result {
            case .failure(_):
                XCTFail("unexpected result")
            case .success(let objects):
                guard objects.count == 1 else {
                    XCTFail("incorrect number of objects")
                    return
                }
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
}
