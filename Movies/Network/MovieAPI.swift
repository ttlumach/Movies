//
//  MovieAPI.swift
//  Movies
//
//  Created by Macbook on 10.07.2024.
//

import Foundation

protocol MovieAPIProtocol {
    func fetchPopularMoviesbyPage(page: Int, onCompletion: @escaping (_ result: Result<MovieResponse, Error>) -> Void)
    func fetchGenres(onCompletion: @escaping (_ result: Result<GenreResponse, Error>) -> Void)
    func fetchVideos(movieID: Int, onCompletion: @escaping (_ result: Result<MovieVideoResponse, Error>) -> Void)
    func fetchMoviesbySearchText(page: Int, searchText: String, onCompletion: @escaping (_ result: Result<MovieResponse, Error>) -> Void)
}

enum MovieURL {
    static private var popularMoviesUrl = baseUrl + "popular"
    static private var image500UrlBase = "https://image.tmdb.org/t/p/w500"
    static private var imageOriginalUrlBase = "https://image.tmdb.org/t/p/original"
    static private var genreUrl = "https://api.themoviedb.org/3/genre/movie/list"
    static private var baseUrl = "https://api.themoviedb.org/3/movie/"
    static private var searchUrl = "https://api.themoviedb.org/3/search/movie"
  
    case getImageURL(filePath: String)
    case getSmallImageURL(filePath: String)
    case getPopularMoviesURL(page: Int)
    case getGenresUrl
    case getTrailerUrl(movieID: Int)
    case getSearchUrl(searchText: String, page: Int)
    
    var url: URL? {
        switch self {
        case .getImageURL(filePath: let path):
            URL(string: Self.imageOriginalUrlBase + path)
        case .getSmallImageURL(filePath: let path):
            URL(string: Self.image500UrlBase + path)
        case .getPopularMoviesURL(let page):
            URL(string: Self.popularMoviesUrl + "?page=\(page)")
        case .getGenresUrl:
            URL(string: Self.genreUrl)
        case .getTrailerUrl(movieID: let id):
            URL(string: Self.baseUrl + String(id) + "/videos")
        case .getSearchUrl(searchText: let text, let page):
            URL(string: Self.searchUrl + "?query=" + text.replacingOccurrences(of: " ", with: "+") + "&page=\(page)")
        }
    }
}

struct MovieAPI: MovieAPIProtocol {

    private let networkSevice: NetworkServiceProtocol = NetworkService()

    func fetchPopularMoviesbyPage(page: Int, onCompletion: @escaping (_ result: Result<MovieResponse, Error>) -> Void)  {
        fetch(url: MovieURL.getPopularMoviesURL(page: page).url) { moviesResult in
            onCompletion(moviesResult)
        }
    }
    
    func fetchMoviesbySearchText(page: Int, searchText: String, onCompletion: @escaping (_ result: Result<MovieResponse, Error>) -> Void)  {
        fetch(url: MovieURL.getSearchUrl(searchText: searchText, page: page).url) { moviesResult in
            onCompletion(moviesResult)
        }
    }
    
    func fetchGenres(onCompletion: @escaping (_ result: Result<GenreResponse, Error>) -> Void) {
        fetch(url: MovieURL.getGenresUrl.url) { genresResult in
            onCompletion(genresResult)
        }
    }
    
    func fetchVideos(movieID: Int, onCompletion: @escaping (_ result: Result<MovieVideoResponse, Error>) -> Void) {
        fetch(url:  MovieURL.getTrailerUrl(movieID: movieID).url) { moviesResult in
            onCompletion(moviesResult)
        }
    }
    
    private func fetch<T: Codable>(url: URL?, onCompletion: @escaping (_ result: Result<T, Error>) -> Void) {
        guard let url = url else { return onCompletion(.failure(NetworkError.badUrl)) }
        
        networkSevice.fetchData(for: url) { result in
            switch result {
            case .success(let data):
                guard let data = data else { return onCompletion(.failure(NetworkError.unknown))}
                
                do {
                    let response = try JSONDecoder().decode(T.self, from: data)
                    onCompletion(.success(response))
                } catch {
                    onCompletion(.failure(NetworkError.decodingError))
                }
            case .failure(let error):
                onCompletion(.failure(error))
            }
        }
    }
}
