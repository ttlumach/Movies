//
//  MovieAPI.swift
//  Movies
//
//  Created by Macbook on 10.07.2024.
//

import Foundation

protocol MovieAPIProtocol {
    
}

enum MovieURL {
    static private var popularMoviesUrl = "https://api.themoviedb.org/3/movie/popular"
    static private var image500UrlBase = "https://image.tmdb.org/t/p/w500"
    static private var imageOriginalUrlBase = "https://image.tmdb.org/t/p/original"
    static private var genreUrl = "https://api.themoviedb.org/3/genre/movie/list"
  
    case getImageURL(filePath: String)
    case getSmallImageURL(filePath: String)
    case getPopularMoviesURL
    case getGenresUrl
    
    var url: URL? {
        switch self {
        case .getImageURL(filePath: let path):
            URL(string: Self.imageOriginalUrlBase + path)
        case .getSmallImageURL(filePath: let path):
            URL(string: Self.image500UrlBase + path)
        case .getPopularMoviesURL:
            URL(string: Self.popularMoviesUrl)
        case .getGenresUrl:
            URL(string: Self.genreUrl)
        }
    }
}

struct MovieAPI: MovieAPIProtocol {

    let networkSevice: NetworkServiceProtocol = NetworkService()

    func fetchMoviesbyPage(page: Int, onCompletion: @escaping (_ result: Result<MovieResponse, Error>) -> Void)  {
        guard let url = MovieURL.getPopularMoviesURL.url else { return }
        networkSevice.fetchData(for: url) { data in
            guard let data = data else { return onCompletion(.failure(MovieError.error))}
            
            do {
                let movieResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
                return onCompletion(.success(movieResponse))
            } catch let error {
                return onCompletion(.failure(MovieError.error))
            }
        }
    }
    
    func fetchGenres(onCompletion: @escaping (_ result: Result<[GenreModel], Error>) -> Void) {
        guard let url = MovieURL.getGenresUrl.url else { return }
        
        networkSevice.fetchData(for: url) { data in
            guard let data = data else { return onCompletion(.failure(MovieError.error))}
            
            do {
                let genresResponse = try JSONDecoder().decode([GenreModel].self, from: data)
                return onCompletion(.success(genresResponse))
            } catch let error {
                return onCompletion(.failure(MovieError.error))
            }
        }
    }
}
