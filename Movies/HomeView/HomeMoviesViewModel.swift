//
//  MovieViewModel.swift
//  Movies
//
//  Created by Macbook on 10.07.2024.
//

import Foundation
import UIKit
import Nuke

protocol HomeMoviesViewModelDelegate: AnyObject {
    func inSearchMode() -> Bool
}

class HomeMoviesViewModel {
    var onMoviesUpdated: (() -> Void)?
    var onErrorMessage: ((Error) -> Void)?
    
    weak var delegate: HomeMoviesViewModelDelegate?
    
    private(set) var popularMovies: [MovieModel] = [] {
        didSet {
            self.onMoviesUpdated?()
        }
    }
    private var popularMoviesCurrentPage = 1
    private var popularMoviesLastPage = 1
    
    private(set) var genresDictionary: [Int: String] = [:] // ID: Name
    
    private(set) var searchedMovies: [MovieModel] = []  {
        didSet {
            self.onMoviesUpdated?()
        }
    }
    private var searchedMoviesCurrentPage = 1
    private var searchedMoviesLastPage = 1
    
    var filteredMovies: [MovieModel] {
        if delegate?.inSearchMode() == true {
            return sortedMovies(searchedMovies)
        } else {
            return sortedMovies(popularMovies)
        }
    }
    
    var filterState = SortState.none
    
    private let api: MovieAPIProtocol = MovieAPI()
    
    init() {
        fetchMoviesByPopularity()
        fetchGenres()
    }
    
    private func sortedMovies(_ movies: [MovieModel]) -> [MovieModel] {
        guard filterState != .none else { return movies }
        return movies.sorted { filterState == .asc ? $0.title < $1.title  : $0.title > $1.title }
    }
    
    func refresh() async {
        api.fetchPopularMoviesbyPage(page: 1) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let response):
                let newItems = response.results.filter { !strongSelf.popularMovies.contains($0) }
                if !newItems.isEmpty {
                    strongSelf.popularMovies.insert(contentsOf: newItems, at: 0)
                }
            case .failure(let error):
                self?.onErrorMessage?(error)
            }
        }
    }
    
    func fetchMoviesByPopularity() {
        guard popularMoviesCurrentPage <= popularMoviesLastPage else { return }
        api.fetchPopularMoviesbyPage(page: popularMoviesCurrentPage) { [weak self] result in
            switch result {
            case .success(let response):
                self?.popularMovies.append(contentsOf: response.results)
                self?.popularMoviesLastPage = response.totalPages
                self?.popularMoviesCurrentPage += 1
            case .failure(let error):
                self?.onErrorMessage?(error)
            }
        }
    }
    
    func fetchMoviesBySearchText(searchText: String) {
        guard searchedMoviesCurrentPage <= searchedMoviesLastPage else { return }
        api.fetchMoviesbySearchText(page: searchedMoviesCurrentPage, searchText: searchText) { [weak self] result in
            switch result {
            case .success(let response):
                self?.searchedMovies.append(contentsOf: response.results)
                self?.searchedMoviesLastPage = response.totalPages
                self?.searchedMoviesCurrentPage += 1
            case .failure(let error):
                self?.onErrorMessage?(error)
            }
        }
    }
    
    private func fetchGenres() {
        api.fetchGenres() { [weak self] result in
            switch result {
            case .success(let response):
                let genres = response.genres
                for genre in genres {
                    self?.genresDictionary[genre.id] = genre.name
                }
                self?.onMoviesUpdated?()
            case .failure(let error):
                self?.onErrorMessage?(error)
            }
        }
    }
}

extension HomeMoviesViewModel {
    
    public func searchControllerUpdatedWith(searchText: String?) {
        searchedMovies = []
        searchedMoviesLastPage = 1
        searchedMoviesCurrentPage = 1
        
        if let searchText = searchText?.lowercased() {
            guard !searchText.isEmpty else {
                self.onMoviesUpdated?()
                return
            }
            
            fetchMoviesBySearchText(searchText: searchText)
        }
    }
}
