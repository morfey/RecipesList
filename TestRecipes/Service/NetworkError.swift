//
//  NetworkError.swift
//  TestRecipes
//
//  Created by Tymofii Hazhyi on 8/7/19.
//  Copyright © 2019 Tymofii Hazhyi. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case authenticationError
    case badRequest
    case failed
    case emptyData
    case decodeFailure
}

extension NetworkError {
    var localizedDescription: String {
        switch self {
        case .authenticationError:
            return "Authentication error"
        case .badRequest:
            return "Bad request"
        case .failed:
            return "Request failed"
        case .emptyData:
            return "Empty response"
        case .decodeFailure:
            return "Decode failure"
        }
    }
}
