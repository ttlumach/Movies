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

class HomeViewController: UIViewControllerWithSpinner {
    
    private let emptyResultsText = "There are no results for your search query."
    private let searchController: UISearchController = UISearchController(searchResultsController: nil)
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.register(UINib(nibName: "HomeMovieTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeMovieTableViewCell")
        tv.backgroundColor = .systemBackground
        return tv
    }()
    
    var viewModel: HomeMoviesViewModel = HomeMoviesViewModel()
    
    private var filterButton: UIBarButtonItem = UIBarButtonItem(image: .init(systemName: "line.3.horizontal.decrease")?.withTintColor(.black, renderingMode: .alwaysOriginal), style: .plain, target: nil , action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        viewModel.onMoviesUpdated = { [weak self] in
            self?.handleMoviesUpdate()
        }
        
        viewModel.onErrorMessage = { [weak self] error in
            self?.stopSpinner()
            self?.displayErrorAlert(error: error)
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
        tableView.separatorStyle = .none
        tableView.snp.makeConstraints { make in
            make.bottom.trailing.top.leading.equalToSuperview()
        }
        setupRefreshControll()
        setupSearchController()
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
    
    private func setupRefreshControll() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func handleMoviesUpdate() {
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            
            let inSearchMode = sSelf.viewModel.inSearchMode(sSelf.searchController)
            let tableViewIsEmpty = inSearchMode ? sSelf.viewModel.filteredMovies.isEmpty : sSelf.viewModel.allMovies.isEmpty
            
            if tableViewIsEmpty {
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: sSelf.tableView.bounds.size.width, height: sSelf.tableView.bounds.size.height))
                label.text = sSelf.emptyResultsText
                label.textAlignment = .center
                
                sSelf.tableView.backgroundView = label
            } else {
                sSelf.tableView.backgroundView = nil
            }
            sSelf.tableView.reloadData()
            sSelf.stopSpinner()
        }
    }
    
    @objc private func refreshData() {
        Task {
            await viewModel.refresh()
            tableView.refreshControl?.endRefreshing()
        }
    }
    
    @objc private func presentSortOptions() {
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
    
    private func sortOptionSelected(_ sortOption: SortState) {
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
        
        let cellViewModel = MovieViewModel(movie: movie, genresDictionary: viewModel.genresDictionary)
        cell.setupWithViewModel(cellViewModel)
        cell.selectionStyle = .none
        
        // - for fetch more on scroll
        if let visiblePaths = tableView.indexPathsForVisibleRows,
           !inSearchMode,
           visiblePaths.contains([0, viewModel.allMovies.count - 1]) {
            viewModel.fetchMovies()
            startSpinner()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let inSearchMode = self.viewModel.inSearchMode(searchController)
        let movie = inSearchMode ? self.viewModel.filteredMovies[indexPath.row] : self.viewModel.allMovies[indexPath.row]
        
        let cellViewModel = MovieViewModel(movie: movie, genresDictionary: viewModel.genresDictionary)
        
        let vc = MovieAdditionalDetailsVC()
        vc.viewModel = cellViewModel
        
        navigationController?.pushViewController(vc, animated: true)
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
    private var spinner = UIActivityIndicatorView(style: .large)

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
