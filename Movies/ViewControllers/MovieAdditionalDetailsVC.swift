//
//  MovieAdditionalDetailsVC.swift
//  Movies
//
//  Created by Macbook on 13.07.2024.
//

import UIKit
import NukeUI
import Nuke
import SnapKit
class MovieAdditionalDetailsVC: UIViewControllerWithSpinner {
    
    var viewModel: MovieViewModel?
    
    private var movieImageView = LazyImageView()
    private var titleLabel = UILabel()
    private var releaseDateLabel = UILabel()
    private var genresLabel = UILabel()
    private var ratingLabel = UILabel()
    private var videosButton = UIButton()
    private var overviewLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
        setupUI()
        
        title = viewModel?.title
        viewModel?.loadAdditionalDetails()
        view.backgroundColor = .background
        
        viewModel?.onVideosUpdated = { [weak self] in
            self?.updateVideosButtonState()
            self?.setMenuItems()
        }
        
        viewModel?.onErrorMessage = { [weak self] error in
            self?.displayErrorAlert(error: error)
        }
    }
    
    private func setupUI() {
        view.addSubview(movieImageView)
        movieImageView.snp.makeConstraints { make in
            make.height.equalTo(300)
            make.trailing.leading.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        view.addSubview(titleLabel)
        titleLabel.textColor = .primaryText
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(movieImageView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        view.addSubview(releaseDateLabel)
        releaseDateLabel.textColor = .secondaryText
        releaseDateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
        }
        
        view.addSubview(genresLabel)
        genresLabel.textColor = .primaryText
        genresLabel.snp.makeConstraints { make in
            make.top.equalTo(releaseDateLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
        }
        genresLabel.numberOfLines = 3
        
        view.addSubview(videosButton)
        videosButton.snp.makeConstraints { make in
            make.top.equalTo(genresLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
        }
        
        view.addSubview(ratingLabel)
        ratingLabel.textColor = .primaryText
        ratingLabel.snp.makeConstraints { make in
            make.centerY.equalTo(videosButton.snp.centerY)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        view.addSubview(overviewLabel)
        overviewLabel.textColor = .primaryText
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(videosButton.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
    }
    
    private func setupData() {
        guard let viewModel = viewModel else { return }
        titleLabel.text = viewModel.title
        titleLabel.numberOfLines = 2
        titleLabel.font = .boldSystemFont(ofSize: 30)
        
        releaseDateLabel.text = viewModel.releaseDate
        releaseDateLabel.font = .boldSystemFont(ofSize: 16)
        
        genresLabel.text = viewModel.genres
        genresLabel.numberOfLines = 3
        genresLabel.font = .boldSystemFont(ofSize: 16)
        
        ratingLabel.text = LocalizedString.rating + " " + viewModel.rating
        ratingLabel.font = .boldSystemFont(ofSize: 16)
        
        overviewLabel.text = viewModel.overview
        overviewLabel.numberOfLines = .max
        
        videosButton.setImage(UIImage(systemName: "play.rectangle")?.withTintColor(.red), for: .normal)
        
        updateVideosButtonState()
        
        setupImageView()
    }
    
    private func setMenuItems(){
        guard let viewModel = viewModel else { return }
        
        var trailerItems: [UIAction] = []
        
        for video in viewModel.videos {
            let url = viewModel.getFullVideoURL(videoKey: video.key)
            let title = video.type + ": " + video.name
            let action = UIAction(title: title) { [weak self] _ in self?.videoButtonTapped(withURL: url) }
            trailerItems.append(action)
        }
        
        videosButton.menu = UIMenu(title: LocalizedString.videos, children: trailerItems)
        videosButton.showsMenuAsPrimaryAction = true
    }
    
    private func updateVideosButtonState() {
            videosButton.isHidden = viewModel?.videos.isEmpty ?? true
    }
    
    private func setupImageView() {
        movieImageView.layer.shadowColor = UIColor.black.cgColor
        movieImageView.layer.shadowRadius = 4
        movieImageView.layer.shadowOpacity = 0.8
        movieImageView.layer.shadowOffset = CGSize(width: 2, height: 1)
        movieImageView.layer.masksToBounds = false
        movieImageView.imageView.contentMode = .scaleAspectFill
        movieImageView.imageView.clipsToBounds = true
        
        if let url = viewModel?.posterImageUrl ?? viewModel?.imageUrl {
            movieImageView.placeholderView = UIActivityIndicatorView()
            movieImageView.priority = .veryHigh
            let imagePipeline = ImagePipeline(configuration: .withDataCache)
            movieImageView.pipeline = imagePipeline
            movieImageView.url = url
        } else {
            movieImageView.imageView.image = viewModel?.defaultImage
        }
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedOnImage))
        movieImageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc private func tappedOnImage() {
        guard let url = viewModel?.posterImageUrl else { 
            displayErrorAlert(error: NetworkError.badUrl)
            return
        }
        guard let vc = viewModel?.createFullScreenImageVC(imageUrl: url) else { return }
        self.present(vc, animated: true, completion: nil)
    }

    @objc private func videoButtonTapped(withURL videoURL: URL?) {
        guard let url = videoURL else {
           displayErrorAlert(error:  NetworkError.badUrl)
            return
        }

        let playerVC = YouTubePlayerVC()
            playerVC.url = url
            present(playerVC, animated: true, completion: nil)
    }
}
