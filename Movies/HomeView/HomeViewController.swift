//
//  ViewController.swift
//  Movies
//
//  Created by Macbook on 04.07.2024.
//

import UIKit
import SnapKit

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
    
    var viewModel: MoviesViewModel = MoviesViewModel()
    
    var filterButton: UIBarButtonItem = UIBarButtonItem(image: .init(systemName: "line.3.horizontal.decrease")?.withTintColor(.black, renderingMode: .alwaysOriginal), style: .plain, target: nil , action: nil)
    
    var spinnerVC = SpinnerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSearchController()
        
        viewModel.onMoviesUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.stopSpinner()
            }
        }
    }
    
    private func setupUI() {
        title = "PopularMovies"
        filterButton.action = #selector(presentSortOptions)
        filterButton.target = self
        navigationItem.rightBarButtonItem = filterButton
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.snp.makeConstraints { make in
            make.bottom.trailing.top.leading.equalToSuperview()
        }
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        
        navigationItem.searchController = searchController
        definesPresentationContext = false
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchController.delegate = self
        searchController.searchBar.delegate = self
    }
    
    @objc func presentSortOptions() {
        let ascAction = UIAlertAction(title: "Asc", style: .default) { (UIAlertAction) in
            self.sortOptionSelected(.asc)
        }
        
        let descAction = UIAlertAction(title: "Desc", style: .default) { (UIAlertAction) in
            self.sortOptionSelected(.desc)
        }
        
        let noneAction = UIAlertAction(title: "None", style: .default) { (UIAlertAction) in
            self.sortOptionSelected(.none)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        displayAlert(title: "Sort options", message: "Please Select an Option", actions: [ascAction, descAction, noneAction, cancelAction], prefrerredStyle: .actionSheet)
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
    }
    
    func displayAlert(title: String, message: String, actions: [UIAlertAction]? = nil, prefrerredStyle: UIAlertController.Style = .alert) {
      let alertController = UIAlertController(title: title, message: message, preferredStyle: prefrerredStyle)
      actions?.forEach { action in
        alertController.addAction(action)
      }
      present(alertController, animated: true)
    }
    
    func startSpinner() {
        addChild(spinnerVC)
        spinnerVC.view.frame = view.frame
        view.addSubview(spinnerVC.view)
        spinnerVC.didMove(toParent: self)
    }
    
    func stopSpinner() {
        spinnerVC.willMove(toParent: nil)
        spinnerVC.view.removeFromSuperview()
        spinnerVC.removeFromParent()
    }
    
}

// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        15
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
}

// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let inSearchMode = self.viewModel.inSearchMode(searchController)
        return inSearchMode ? self.viewModel.filteredMovies.count : self.viewModel.allMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeMovieTableViewCell", for: indexPath) as? HomeTableViewCell else {
            return UITableViewCell()
        }
        let inSearchMode = self.viewModel.inSearchMode(searchController)
        let movie = inSearchMode ? self.viewModel.filteredMovies[indexPath.row] : self.viewModel.allMovies[indexPath.row]
        
        let cellViewModel = HomeTableViewCellViewModel(movie: movie, genresDictionary: viewModel.genresDictionary)
        cell.setupWithViewModel(cellViewModel)
        
        // - for fetch more on scroll
        if let visiblePaths = tableView.indexPathsForVisibleRows,
           !inSearchMode,
           visiblePaths.contains([0, viewModel.allMovies.count - 1]) {
            viewModel.fetchMovies()
            startSpinner()
        }
        
        return cell
    }
}

// MARK: - Search

extension HomeViewController: UISearchResultsUpdating,
                              UISearchControllerDelegate,
                              UISearchBarDelegate  {
    
    func updateSearchResults(for searchController: UISearchController) {
        self.viewModel.updateSearchController(searchBarText: searchController.searchBar.text)
    }
}

class SpinnerViewController: UIViewController {
    var spinner = UIActivityIndicatorView(style: .large)

    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.5)

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
