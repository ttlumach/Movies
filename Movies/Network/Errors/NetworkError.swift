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
            LocalizedString.unnownError
        case .badUrl:
            "Bad URL"
        case .decodingError:
            "Error parsing server response."
        case .serverError(let error):
            "Server Error found.\n" + error.statusMessage
        case .noInternet:
            LocalizedString.youAreOffline
        case .cantLoadImage:
            "Cannot load image from url"
        }
    }
}
