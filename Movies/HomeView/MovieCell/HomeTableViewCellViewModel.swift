//
//  HomeTableViewCellViewModel.swift
//  Movies
//
//  Created by Macbook on 14.07.2024.
//

import Foundation
import UIKit


class HomeTableViewCellViewModel {
    var movie: MovieModel
    let defaultImage = UIImage(named: "defaultMovieImage")
    
    var genresDictionary: [Int: String] // ID: Name
    
    var title: String {
        movie.title
    }
    
    var year: String {
        movie.releaseDate
    }
    
    var rating: Double {
        movie.voteAverage
    }
    
    var genres: String {
        getGenreNamesFromIDs(IDs: movie.genreIDs)
    }
    
    var imageUrl: URL? {
        let imagePath = movie.backdropPath ?? movie.posterPath ?? ""
        return MovieURL.getSmallImageURL(filePath: imagePath).url
    }
    
    init(movie: MovieModel, genresDictionary: [Int : String]) {
        self.movie = movie
        self.genresDictionary = genresDictionary
    }
    
    private func getGenreNamesFromIDs(IDs: [Int]) -> String {
        var genres = IDs.reduce("") {
            return $0 + ", " + (genresDictionary[$1] ?? "")
        }
        genres.removeFirst(2) // removes ", " at start
        
        return genres
    }
}
