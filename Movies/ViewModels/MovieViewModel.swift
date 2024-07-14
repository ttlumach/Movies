//
//  HomeTableViewCellViewModel.swift
//  Movies
//
//  Created by Macbook on 14.07.2024.
//

import Foundation
import UIKit


class MovieViewModel {
    private var movie: MovieModel
    let defaultImage = UIImage(named: "defaultMovieImage")
    
    var genresDictionary: [Int: String] // ID: Name
    
    var title: String {
        movie.title
    }
    
    var year: String {
        getYearFromDateString(movie.releaseDate) ?? movie.releaseDate
    }
    
    var rating: String {
        String(format: "%.2f", movie.voteAverage)
    }
    
    var genres: String {
        getGenreNamesFromIDs(IDs: movie.genreIDs)
    }
    
    var smallImageUrl: URL? {
        let imagePath = movie.backdropPath ?? movie.posterPath ?? ""
        return MovieURL.getSmallImageURL(filePath: imagePath).url
    }
    
    var imageUrl: URL? {
        let imagePath = movie.backdropPath ?? movie.posterPath ?? ""
        return MovieURL.getImageURL(filePath: imagePath).url
    }
    
    var yearAndCountry: String {
        year + ", " + movie.originalLanguage
    }
    
    var overview: String {
        movie.overview
    }
    
    var releaseDate: String {
        movie.releaseDate
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
    
    private func getYearFromDateString(_ dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = dateFormatter.date(from: dateString) {
            let calendar = Calendar.current
            let year = calendar.component(.year, from: date)
            return String(year)
        } else {
            return nil
        }
    }
}