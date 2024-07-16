//
//  MovieServiceError.swift
//  Movies
//
//  Created by Macbook on 14.07.2024.
//

import Foundation

enum NetworkError: Error {
    case serverError(MovieResponseError)
    case unknown
    case badUrl
    case decodingError
    case noInternet
    
    var localizedDescription: String {
        switch self {
        case .unknown:
            "An unknown error occurred."
        case .badUrl:
            "Bad URL"
        case .decodingError:
            "Error parsing server response."
        case .serverError(let error):
            "Server Error found.\n" + error.statusMessage
        case .noInternet:
            "You are offline.\nPlease, enable your Wi-Fi or connect using cellular data."
        }
    }
}
