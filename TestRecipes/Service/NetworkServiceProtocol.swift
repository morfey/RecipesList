//
//  NetworkServiceProtocol.swift
//  TestRecipes
//
//  Created by Tymofii Hazhyi on 8/6/19.
//  Copyright © 2019 Tymofii Hazhyi. All rights reserved.
//

import Foundation

protocol NetworkServiceProtocol {
    func request<T: Codable>(api: RecipesApi, completion: @escaping (Result<[T], Error>) -> ())
}
