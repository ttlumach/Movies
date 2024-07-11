//
//  MovieResponse.swift
//  Movies
//
//  Created by Macbook on 10.07.2024.
//

import Foundation

struct MovieResponse: Codable {
    let page: Int
    let results: [MovieModel]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
