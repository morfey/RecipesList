//
//  NetworkService.swift
//  TestRecipes
//
//  Created by Tymofii Hazhyi on 6/25/19.
//  Copyright © 2019 Tymofii Hazhyi. All rights reserved.
//

import Foundation

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}

public enum HTTPMethod : String {
    case get = "GET"
}

public enum HTTPTask {
    case request
}

public typealias HTTPHeaders = [String: String]

struct NetworkService: NetworkServiceProtocol {
    let router = Router<RecipesApi>()
    
    func request<T: Codable>(api: RecipesApi, completion: @escaping (Result<[T], Error>) -> ()) {
        router.request(api) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(.failure(NetworkError.emptyData))
                        return
                    }
                    do {
                        let apiResponse = try JSONDecoder().decode([T].self, from: responseData)
                        completion(.success(apiResponse))
                    } catch {
                        completion(.failure(NetworkError.decodeFailure))
                    }
                case .failure(let networkFailureError):
                    completion(.failure(networkFailureError))
                }
            }
        }
    }
    
    func getRecipesList(completion: @escaping (Result<[Recipe], Error>) -> ()) {
        request(api: .list, completion: completion)
    }
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<Any, Error> {
        switch response.statusCode {
        case 200...299: return .success(response)
        case 401...500: return .failure(NetworkError.authenticationError)
        case 501...599: return .failure(NetworkError.badRequest)
        default: return .failure(NetworkError.failed)
        }
    }
}
