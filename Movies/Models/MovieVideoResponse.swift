//
//  MovieVideoResponse.swift
//  Movies
//
//  Created by Macbook on 15.07.2024.
//

import Foundation

struct MovieVideoResponse: Codable {
    var id: Int
    var results: [Video]
}

struct Video: Codable {
    var iso6391: String
    var iso31661: String
    var name: String
    var key: String
    var site: String
    var size: Int
    var type: String
    var official: Bool
    var publishedAt: String
    var id: String

    enum CodingKeys: String, CodingKey {
        case iso6391 = "iso_639_1"
        case iso31661 = "iso_3166_1"
        case name
        case key
        case site
        case size
        case type
        case official
        case publishedAt = "published_at"
        case id
    }
}
