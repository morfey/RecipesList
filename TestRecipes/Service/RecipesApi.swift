//
//  RecipesApi.swift
//  TestRecipes
//
//  Created by Tymofii Hazhyi on 6/25/19.
//  Copyright © 2019 Tymofii Hazhyi. All rights reserved.
//

import Foundation

public enum RecipesApi {
    case list
}

extension RecipesApi: EndPointType {
    var baseURL: URL {
        guard let url = URL(string: "http://mobile.asosservices.com/sampleapifortest/") else { fatalError("baseURL not configured")}
        return url
    }
    
    var path: String {
        switch self {
        case .list:
            return "recipes.json"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        return .request
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}

struct RecipesApiResponse: Codable {
    let items: [Recipe]
}
