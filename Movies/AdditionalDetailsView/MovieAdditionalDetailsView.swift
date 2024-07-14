//
//  MovieAdditionalDetailsView.swift
//  Movies
//
//  Created by Macbook on 13.07.2024.
//

import UIKit
import NukeUI
import Nuke
import SnapKit

class MovieAdditionalDetailsVC: UIViewController {
    
    var viewModel: MovieViewModel?
    
    var movieImageView = LazyImageView()
    var titleLabel = UILabel()
    var releaseDateLabel = UILabel()
    var genresLabel = UILabel()
    var ratingLabel = UILabel()
    var trailerButton = UIButton()
    var overviewLabel = UILabel()
    
    override func viewDidLoad() {
        setupData()
        setupUI()
        title = viewModel?.title
        view.backgroundColor = .white
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
            make.trailing.leading.equalToSuperview().offset(10)
        }
    }
    
    private func setupData() {
        titleLabel.text = viewModel?.title
        titleLabel.numberOfLines = 4
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
        //trailerButton.isHidden = viewModel
        
        setupImageView()
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
            movieImageView.pipeline = ImagePipeline.shared
            movieImageView.url = url
        } else {
            movieImageView.imageView.image = viewModel?.defaultImage
        }
    }
    
    private func trailerButtonTapped() {
        
    }
}
