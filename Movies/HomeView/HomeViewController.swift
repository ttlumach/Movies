//
//  ViewController.swift
//  Movies
//
//  Created by Macbook on 04.07.2024.
//

import UIKit
import SnapKit

class HomeViewController: UIViewControllerWithSpinner {
    
    private let emptyResultsText = LocalizedString.noResultsForQuery
    private let searchController: UISearchController = UISearchController(searchResultsController: nil)
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.register(UINib(nibName: "HomeMovieTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeMovieTableViewCell")
        tv.backgroundColor = .systemBackground
        return tv
    }()
    
    var viewModel: HomeMoviesViewModel = HomeMoviesViewModel()
    
    private var sortBarButtonItem: UIBarButtonItem = UIBarButtonItem(image: .init(systemName: "line.3.horizontal.decrease")?.withTintColor(.secondaryText, renderingMode: .alwaysOriginal), style: .plain, target: nil , action: nil)
    
    private var settingsBarButtonItem: UIBarButtonItem = UIBarButtonItem(image: .init(systemName: "gearshape")?.withTintColor(.secondaryText, renderingMode: .alwaysOriginal), style: .plain, target: nil , action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        viewModel.delegate = self
        viewModel.onMoviesUpdated = { [weak self] in
            self?.handleMoviesUpdate()
        }
        
        viewModel.onErrorMessage = { [weak self] error in
            self?.stopSpinner()
            self?.displayErrorAlert(error: error)
        }
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.snp.makeConstraints { make in
            make.bottom.trailing.top.leading.equalToSuperview()
        }
        setupRefreshControll()
        setupSearchController()
        createSortMenu()
        
        title = LocalizedString.popularMovies
        sortBarButtonItem.target = self
        settingsBarButtonItem.target = self
        settingsBarButtonItem.action = #selector(showSettings)
        navigationItem.rightBarButtonItem = sortBarButtonItem
        navigationItem.leftBarButtonItem = settingsBarButtonItem
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = LocalizedString.searchMovies
        
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
    
    @objc private func showSettings() {
        let vc = SettingsViewController()
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleMoviesUpdate() {
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            
            let tableViewIsEmpty = sSelf.viewModel.filteredMovies.isEmpty
            
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
    
    // MARK: - Sort Menu
    
    private func updateMenuActionState() {
        sortBarButtonItem.menu?.children.forEach { action in
            guard let action = action as? UIAction else {
                return
            }
            if action.title == viewModel.sortOptionSelected.name {
                action.state = .on
            } else {
                action.state = .off
            }
        }
    }
    
    private func createSortMenu() {
        let menuSortItems: [UIAction] = [
            UIAction(title: SortState.asc.name) {[weak self] _ in self?.sortOptionSelected(.asc)},
            UIAction(title: SortState.desc.name) {[weak self] _ in self?.sortOptionSelected(.desc)},
            UIAction(title: SortState.none.name) {[weak self] _ in self?.sortOptionSelected(.none)}
        ]
        
        let menu =  UIMenu(title: LocalizedString.sortByName.uppercased(), children: menuSortItems)
        
        sortBarButtonItem.menu = menu
        updateMenuActionState()
    }
    
    private func sortOptionSelected(_ sortOption: SortState) {
        viewModel.sortOptionSelected = sortOption
        
        switch sortOption {
        case .asc:
            sortBarButtonItem.image = .init(systemName: "menubar.arrow.down.rectangle")?.withTintColor(.secondaryText, renderingMode: .alwaysOriginal)
        case .desc:
            sortBarButtonItem.image = .init(systemName: "menubar.arrow.up.rectangle")?.withTintColor(.secondaryText, renderingMode: .alwaysOriginal)
        case .none:
            sortBarButtonItem.image = .init(systemName: "line.3.horizontal.decrease")?.withTintColor(.secondaryText, renderingMode: .alwaysOriginal)
        }
        updateMenuActionState()
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
        return self.viewModel.filteredMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeMovieTableViewCell", for: indexPath) as? HomeTableViewCell else {
            return UITableViewCell()
        }
        
        let movie = self.viewModel.filteredMovies[indexPath.row]
        let cellViewModel = MovieViewModel(movie: movie, genresDictionary: viewModel.genresDictionary)
        cell.setupWithViewModel(cellViewModel)
        cell.selectionStyle = .none
        
        // - for fetch more on scroll
        if let visiblePaths = tableView.indexPathsForVisibleRows,
           visiblePaths.contains([0, viewModel.filteredMovies.count - 1]) {
            if !viewModel.onLastPage {
                viewModel.loadNextPage()
                startSpinner()
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = self.viewModel.filteredMovies[indexPath.row]
        
        let cellViewModel = MovieViewModel(movie: movie, genresDictionary: viewModel.genresDictionary)
        
        let vc = MovieAdditionalDetailsVC()
        vc.viewModel = cellViewModel
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Search

extension HomeViewController: UISearchResultsUpdating,
                              UISearchControllerDelegate,
                              UISearchBarDelegate,
                              HomeMoviesViewModelDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text?.isEmpty == true {
            tableView.reloadData()
        }
    }
    
    
    func inSearchMode() -> Bool {
        let isActive = searchController.isActive
        let searchText = searchController.searchBar.text ?? ""
        
        return isActive && !searchText.isEmpty
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.viewModel.searchControllerUpdatedWith(searchText: searchController.searchBar.text)
    }
}
