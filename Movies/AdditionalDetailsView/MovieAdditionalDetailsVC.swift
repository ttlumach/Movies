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
import AVFoundation
import AVKit

class MovieAdditionalDetailsVC: UIViewControllerWithSpinner {
    
    var viewModel: MovieViewModel?
    
    private var movieImageView = LazyImageView()
    private var titleLabel = UILabel()
    private var releaseDateLabel = UILabel()
    private var genresLabel = UILabel()
    private var ratingLabel = UILabel()
    private var trailerButton = UIButton()
    private var overviewLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
        setupUI()
        
        title = viewModel?.title
        view.backgroundColor = .white
        
        viewModel?.onTrailerUpdated = { [weak self] in
            self?.updateTrailerButtonState()
        }
        
        viewModel?.onErrorMessage = { [weak self] error in
            self?.displayErrorAlert(error: error)
        }
    }
    
    private func setupUI() {
        view.addSubview(movieImageView)
        movieImageView.snp.makeConstraints { make in
            make.height.equalTo(200)
            make.trailing.leading.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(movieImageView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        view.addSubview(releaseDateLabel)
        releaseDateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
        }
        
        view.addSubview(genresLabel)
        genresLabel.snp.makeConstraints { make in
            make.top.equalTo(releaseDateLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
        }
        genresLabel.numberOfLines = 3
        
        view.addSubview(trailerButton)
        trailerButton.snp.makeConstraints { make in
            make.top.equalTo(genresLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
        }
        
        view.addSubview(ratingLabel)
        ratingLabel.snp.makeConstraints { make in
            make.centerY.equalTo(trailerButton.snp.centerY)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        view.addSubview(overviewLabel)
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(trailerButton.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
    }
    
    private func setupData() {
        titleLabel.text = viewModel?.title
        titleLabel.numberOfLines = 2
        titleLabel.font = .boldSystemFont(ofSize: 30)
        
        releaseDateLabel.text = viewModel?.releaseDate
        releaseDateLabel.font = .boldSystemFont(ofSize: 16)
        
        genresLabel.text = viewModel?.genres
        genresLabel.numberOfLines = 3
        genresLabel.font = .boldSystemFont(ofSize: 16)
        
        ratingLabel.text = "Rating: " + (viewModel?.rating ?? "")
        ratingLabel.font = .boldSystemFont(ofSize: 16)
        
        overviewLabel.text = viewModel?.overview
        overviewLabel.numberOfLines = .max
        
        trailerButton.setImage(UIImage(systemName: "play.rectangle")?.withTintColor(.red), for: .normal)
        trailerButton.addTarget(self, action: #selector(trailerButtonTapped), for: .touchUpInside)
        updateTrailerButtonState()
        
        setupImageView()
    }
    
    private func updateTrailerButtonState() {
        trailerButton.isHidden = viewModel?.trailerUrl == nil
    }
    
    private func setupImageView() {
        movieImageView.layer.shadowColor = UIColor.black.cgColor
        movieImageView.layer.shadowRadius = 6
        movieImageView.layer.shadowOpacity = 0.8
        movieImageView.layer.shadowOffset = CGSize(width: 2, height: 1)
        movieImageView.layer.masksToBounds = false
        movieImageView.contentMode = .scaleAspectFit
        
        if let url = viewModel?.imageUrl {
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
        
        Task {
            do {
                let imagePipeline = ImagePipeline(configuration: .withDataCache)
                let vc = FullScreenImageViewController()
                
                startSpinner()
                let image = try await imagePipeline.image(for: url)
                vc.image = image
                stopSpinner()
                
                self.present(vc, animated: true, completion: nil)
            } catch let error {
                displayErrorAlert(error: error)
            }
            
        }
    }

    @objc private func trailerButtonTapped() {
        guard let url = viewModel?.trailerUrl else {
           displayErrorAlert(error:  NetworkError.badUrl)
            return
        }

        let playerVC = YouTubePlayerVC()
            playerVC.url = url
            present(playerVC, animated: true, completion: nil)
    }
}
