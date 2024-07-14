//
//  MovieServiceError.swift
//  Movies
//
//  Created by Macbook on 14.07.2024.
//

import Foundation

enum MovieServiceError: Error {
    case serverError(MovieError)
    case unknown(String = "An unknown error occurred.")
    case badUrl(String = "Bad URL")
    case decodingError(String = "Error parsing server response.")
}
