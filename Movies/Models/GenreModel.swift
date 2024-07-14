//
//  GenreModel.swift
//  Movies
//
//  Created by Macbook on 14.07.2024.
//

import Foundation

struct GenreResponse: Codable {
    var genres: [GenreModel]
}

struct GenreModel: Codable {
    var id: Int
    var name: String
}
