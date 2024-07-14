//
//  MovieServiceError.swift
//  Movies
//
//  Created by Macbook on 14.07.2024.
//

import Foundation

enum MovieServiceError: Error {
    case serverError(MovieError)
    case unknown
    case badUrl
    case decodingError
    
    var localizedDescription: String {
        switch self {
        case .unknown:
            "An unknown error occurred."
        case .badUrl:
            "Bad URL"
        case .decodingError:
            "Error parsing server response."
        case .serverError(let error):
            error.statusMessage
        }
    }
}
