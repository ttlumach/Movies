//
//  HomeTableViewCellViewModel.swift
//  Movies
//
//  Created by Macbook on 14.07.2024.
//

import Foundation
import UIKit
import Nuke

class MovieViewModel {
    private var movie: MovieModel
    private let api: MovieAPIProtocol = MovieAPI()
    private let youtubeURLBase = "https://www.youtube.com/watch?v="
    
    var onTrailerUpdated: (() -> Void)?
    var onErrorMessage: ((Error) -> Void)?
    
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
        guard let imagePath = movie.backdropPath ?? movie.posterPath else { return nil }
        return MovieURL.getSmallImageURL(filePath: imagePath).url
    }
    
    var imageUrl: URL? {
        guard let imagePath = movie.backdropPath ?? movie.posterPath else { return nil }
        return MovieURL.getImageURL(filePath: imagePath).url
    }
    
    var posterImageUrl: URL? {
        guard let imagePath = movie.posterPath else { return nil }
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
    
    var trailerUrl: URL?
    
    init(movie: MovieModel, genresDictionary: [Int : String]) {
        self.movie = movie
        self.genresDictionary = genresDictionary
        fetchVideo()
    }
    
    private func getGenreNamesFromIDs(IDs: [Int]) -> String {
        guard !IDs.isEmpty else { return "N/A" }
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
    
    private func fetchVideo() {
        api.fetchVideos(movieID: movie.id) { [weak self] result in
            switch result {
            case .success(let response):
                let videos = response.results
                for video in videos {
                    if video.name.lowercased() == "official trailer" {
                        self?.trailerUrl = URL(string: (self?.youtubeURLBase ?? "") + video.key)
                    } else if video.type.lowercased() == "trailer" {
                        self?.trailerUrl = URL(string: (self?.youtubeURLBase ?? "") + video.key)
                    }
                    self?.onTrailerUpdated?()
                }
            case .failure(let error):
                self?.onErrorMessage?(error)
            }
        }
    }
    
    func createFullScreenImageVC(imageUrl: URL) -> FullScreenImageViewController {
        let vc = FullScreenImageViewController(url: imageUrl)
        vc.modalTransitionStyle = .crossDissolve
        return vc
    }
}
