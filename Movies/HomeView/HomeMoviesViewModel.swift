//
//  MovieViewModel.swift
//  Movies
//
//  Created by Macbook on 10.07.2024.
//

import Foundation
import UIKit
import Nuke

class HomeMoviesViewModel {
    var onMoviesUpdated: (() -> Void)?
    var onErrorMessage: ((MovieError) -> Void)?
    
    private(set) var allMovies: [MovieModel] = [] {
        didSet {
            self.onMoviesUpdated?()
        }
    }
    
    private(set) var genresDictionary: [Int: String] = [:] // ID: Name
    
    private(set) var filteredMovies: [MovieModel] = []
    var filterState = SortState.none {
        didSet {
            sort(state: filterState)
        }
    }
    
    private let api: MovieAPIProtocol = MovieAPI()
    private var currentPage = 1
    private var lastPage = 1
    
    init() {
        fetchMovies()
        fetchGenres()
    }
    
    private func sort(state: SortState) {
        guard state != .none else { return }
        allMovies.sort { state == .asc ? $0.title < $1.title  : $0.title > $1.title }
        filteredMovies.sort { state == .asc ? $0.title < $1.title  : $0.title > $1.title }
    }
    
    func fetchMovies() {
        api.fetchMoviesbyPage(page: currentPage) { [weak self] resp in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                if case let .success(response) = resp {
                    self?.allMovies.append(contentsOf: response.results)
                    self?.lastPage = response.totalPages
                    self?.sort(state: self?.filterState ?? .none)
                    self?.currentPage += 1
                }
            }
        }
    }
    
    private func fetchGenres() {
        api.fetchGenres() { response in
            if case let .success(genresResponse) = response {
                let genres = genresResponse.genres
                for genre in genres {
                    self.genresDictionary[genre.id] = genre.name
                }
            }
        }
    }
}

extension HomeMoviesViewModel {
    
    public func inSearchMode(_ searchController: UISearchController) -> Bool {
        let isActive = searchController.isActive
        let searchText = searchController.searchBar.text ?? ""
        
        return isActive && !searchText.isEmpty
    }
    
    public func updateSearchController(searchBarText: String?) {
        self.filteredMovies = allMovies

        if let searchText = searchBarText?.lowercased() {
            guard !searchText.isEmpty else { self.onMoviesUpdated?(); return }
            
            self.filteredMovies = self.filteredMovies.filter({ $0.title.lowercased().contains(searchText) })
        }
        
        self.onMoviesUpdated?()
    }
}
