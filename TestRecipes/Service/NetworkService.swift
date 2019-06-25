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

enum NetworkResponse: String {
    case success
    case authenticationError = "Authentication error"
    case badRequest = "Bad request"
    case failed = "Request failed"
    case emptyData = "Empty response"
    case decodeFailure = "Decode failure"
}

enum Result<String>{
    case success
    case failure(String)
}

public typealias HTTPHeaders = [String: String]

struct NetworkService {
    let router = Router<RecipesApi>()
    
    func getRecipesList(completion: @escaping (_ items: [Recipe]?,_ error: String?) -> ()) {
        router.request(.list) { data, response, error in
            if error != nil {
                completion(nil, error?.localizedDescription)
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.emptyData.rawValue)
                        return
                    }
                    do {
                        let apiResponse = try JSONDecoder().decode(RecipesApiResponse.self, from: responseData)
                        completion(apiResponse.items, nil)
                    } catch {
                        completion(nil, NetworkResponse.decodeFailure.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String> {
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}
