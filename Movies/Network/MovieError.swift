//
//  MovieError.swift
//  Movies
//
//  Created by Macbook on 14.07.2024.
//

import Foundation

struct MovieError: Error, Codable {
    let statusCode: Int
    let statusMessage: String
    let success: Bool
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case success
    }
}
