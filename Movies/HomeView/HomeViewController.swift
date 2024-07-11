//
//  ViewController.swift
//  Movies
//
//  Created by Macbook on 04.07.2024.
//

import UIKit
import SnapKit
import Alamofire

enum SortState {
    case asc, desc, none
}

class HomeViewController: UIViewController {
    
    private let searchController: UISearchController = UISearchController(searchResultsController: nil)
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.register(UINib(nibName: "HomeMovieTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeMovieTableViewCell")
        tv.backgroundColor = .systemBackground
        return tv
    }()
    
    lazy var viewModel: MovieCellViewModel = MovieCellViewModel()
    
    var filterButton: UIBarButtonItem = UIBarButtonItem(image: .init(systemName: "line.3.horizontal.decrease")?.withTintColor(.black, renderingMode: .alwaysOriginal), style: .plain, target: nil , action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSearchController()
        
        self.viewModel.onMoviesUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    private func setupUI() {
        title = "PopularMovies"
        filterButton.action = #selector(presentSortOptions)
        filterButton.target = self
        navigationItem.rightBarButtonItem = filterButton
        
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.snp.makeConstraints { make in
            make.bottom.trailing.top.leading.equalToSuperview()
        }
    }
    
    private func setupSearchController() {
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.placeholder = "Search Movies"
        
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = false
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        searchController.delegate = self
        searchController.searchBar.delegate = self
    }
    
    @objc func presentSortOptions() {
        let alert = UIAlertController(title: "Sort options", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Asc", style: .default) { (UIAlertAction) in
            self.sortOptionSelected(.asc)
        })
        
        alert.addAction(UIAlertAction(title: "Desc", style: .default) { (UIAlertAction) in
            self.sortOptionSelected(.desc)
        })
        
        alert.addAction(UIAlertAction(title: "None", style: .default) { (UIAlertAction) in
            self.sortOptionSelected(.none)
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(alert, animated: true)
    }
    
    func sortOptionSelected(_ sortOption: SortState) {
        viewModel.filterState = sortOption
        
        switch sortOption {
        case .asc:
            filterButton.image = .init(systemName: "menubar.arrow.down.rectangle")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        case .desc:
            filterButton.image = .init(systemName: "menubar.arrow.up.rectangle")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        case .none:
            filterButton.image = .init(systemName: "menubar.rectangle")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        }
        if viewModel.filterState == .asc {
            viewModel.filterState = .desc
            
        } else {
            viewModel.filterState = .asc
           
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        15
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let inSearchMode = self.viewModel.inSearchMode(searchController)
        return inSearchMode ? self.viewModel.filteredMovies.count : self.viewModel.allMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeMovieTableViewCell", for: indexPath) as? HomeMovieTableViewCell else {
            return UITableViewCell()
        }
        let inSearchMode = self.viewModel.inSearchMode(searchController)
        
        
        let movie = inSearchMode ? self.viewModel.filteredMovies[indexPath.row] : self.viewModel.allMovies[indexPath.row]
        let genres = viewModel.genresFor(genreIDs: movie.genreIDs)
        let image = viewModel.imageFor(path: movie.backdropPath ?? movie.posterPath)
        
        cell.setupUI(movieTitle: movie.title, moviewYear: movie.releaseDate, genres: genres, rating: String(movie.voteAverage), image: image)
        
        return cell
    }
}

extension HomeViewController: UISearchResultsUpdating,
                              UISearchControllerDelegate,
                              UISearchBarDelegate  {
    
    func updateSearchResults(for searchController: UISearchController) {
        self.viewModel.updateSearchController(searchBarText: searchController.searchBar.text)
    }
}

class MovieCellViewModel {
    var onMoviesUpdated: (() -> Void)?
    var onErrorMessage: ((MovieError) -> Void)?
    
    private(set) var allMovies: [MovieModel] = [] {
        didSet {
            self.onMoviesUpdated?()
        }
    }
    
    private(set) var filteredMovies: [MovieModel] = []
    var filterState = SortState.asc {
        didSet {
            sort(state: filterState)
        }
    }
    
    private let api: MovieAPI = MovieAPI()
    
    init() {
        fetchMovies()
    }
    
    func sort(state: SortState) {
        allMovies.sort { filterState == .asc ? $0.title < $1.title  : $0.title > $1.title }
        filteredMovies.sort { filterState == .asc ? $0.title < $1.title  : $0.title > $1.title }
    }
    
    func fetchMovies() {
        api.fetchMoviesbyPage(page: 1) { [weak self] result in
            if case let .success(data) = result {
                self?.allMovies.append(contentsOf: data)
                self?.sort(state: self?.filterState ?? .asc)
            }
        }
    }
    
    func imageFor(path: String?) -> UIImage {
        return UIImage(named: "fixture") ?? UIImage()
    }
    
    func genresFor(genreIDs: [Int]) -> String {
        "test genre1, test genre2"
    }
}

extension MovieCellViewModel {
    
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

struct MovieModel: Codable {
    let adult: Bool
    let backdropPath: String?
    let genreIDs: [Int]
    let id: Int
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let releaseDate: String
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDs = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

struct MovieAPI {
    static let baseURL = URL(string: "https://api.themoviedb.org/3/discover/movie")!
    
    let networkSevice: NetworkServiceProtocol = NetworkService()
}

protocol NetworkServiceProtocol {
    func fetchData(for url: URL, completionHandler: @escaping (Data?) -> ())
}

enum MovieError: Error {
    case error
}

struct NetworkService: NetworkServiceProtocol {
    
    let headers = HTTPHeaders([HTTPHeader(name: "accept", value: "application/json"),
                               HTTPHeader(name: "Authorization", value: "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJkZDQ0MGRjMzJiOWJlZTA2NzhiYTc0NDZkMWFjZDAzMyIsIm5iZiI6MTcyMDQ1MjYwOS4xMzE4MjksInN1YiI6IjY2ODZkNzg3OWU1MThkYjA1YjFiZTBjNSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.qjEJ2L9fvnfkdm3xNAXYwHf12YqMtcOlgKOOSBHbQXY")])
    
    func fetchData(for url: URL, completionHandler: @escaping (Data?) -> ()) {
        AF.request(url, headers: headers).responseData { responseData in
            switch responseData.result {
                case .success(let value):
                    completionHandler(value)
                case .failure(let error):
                    print(error)
                }
        }
    }
}

extension MovieAPI {
    
    func fetchMoviesbyPage(page: Int, onCompletion: @escaping (_ result: Result<[MovieModel], Error>) -> Void)  {
        networkSevice.fetchData(for: Self.baseURL) { data in
            guard let data = data else { return onCompletion(.failure(MovieError.error))}
            
            do {
                let movieModels = try JSONDecoder().decode(MovieResponse.self, from: data)
                return onCompletion(.success(movieModels.results))
            } catch let error {
                return onCompletion(.failure(MovieError.error))
            }
        }
    }
}

enum NetworkError: Error {
    case badURL
}
