//
//  MovieServiceError.swift
//  Movies
//
//  Created by Macbook on 14.07.2024.
//

import Foundation
import UIKit

enum NetworkError: LocalizedError {
    case serverError(MovieResponseError)
    case unknown
    case badUrl
    case decodingError
    case noInternet
    case cantLoadImage
    
    var errorDescription: String? {
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
        case .cantLoadImage:
            "Cannot load image from url"
        }
    }
}
