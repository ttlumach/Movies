//
//  HomeMovieTableViewCellModel.swift
//  Movies
//
//  Created by Macbook on 04.07.2024.
//

import UIKit
import NukeUI
import Nuke

class HomeTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var genresLabel: UILabel!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var movieImageView: LazyImageView!
    
    @IBOutlet var genresStaticLabel: UILabel!
    @IBOutlet var ratingStaticLabel: UILabel!
    
    private var viewModel: HomeTableViewCellViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupWithViewModel(_ viewModel: HomeTableViewCellViewModel) {
        self.viewModel = viewModel
        setupUI()
        setupData()
    }
    
    private func setupUI() {
        setupTextBackground()
        
        genresLabel.preferredMaxLayoutWidth = 150
        genresLabel.numberOfLines = 3
        movieImageView.contentMode = .scaleToFill
        movieImageView.layer.shadowColor = UIColor.black.cgColor
        movieImageView.layer.shadowRadius = 6
        movieImageView.layer.shadowOpacity = 0.8
        movieImageView.layer.shadowOffset = CGSize(width: 4, height: 2)
        movieImageView.layer.masksToBounds = false
    }
    
    private func setupTextBackground() {
        setupBackgroungForView(titleLabel)
        setupBackgroungForView(yearLabel)
        setupBackgroungForView(genresLabel)
        setupBackgroungForView(ratingLabel)
        setupBackgroungForView(ratingStaticLabel)
        setupBackgroungForView(genresStaticLabel)
    }
    
    private func setupBackgroungForView(_ uiView: UIView) {
        uiView.layer.cornerRadius = 5
        uiView.layer.masksToBounds = true
        uiView.backgroundColor = .white.withAlphaComponent(0.7)
    }
    
    private func setupImageViewData() {
        if let url = viewModel?.imageUrl {
            movieImageView.placeholderView = UIActivityIndicatorView()
            movieImageView.priority = .veryHigh
            movieImageView.pipeline = ImagePipeline.shared
            movieImageView.url = url
            
            movieImageView.onCompletion = { _ in print("Request completed") }
        } else {
            movieImageView.imageView.image = viewModel?.defaultImage
        }
    }
    
    private func setupData() {
        setupImageViewData()
        titleLabel.text = viewModel?.title
        yearLabel.text = viewModel?.year
        genresLabel.text = viewModel?.genres
        ratingLabel.text = String(viewModel?.rating ?? 0)
    }
}
