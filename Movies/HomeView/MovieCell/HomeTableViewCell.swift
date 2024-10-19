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

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var yearLabel: UILabel!
    @IBOutlet private var genresLabel: UILabel!
    @IBOutlet private var ratingLabel: UILabel!
    @IBOutlet private var movieImageView: LazyImageView!
    
    @IBOutlet private var genresStaticLabel: UILabel!
    @IBOutlet private var ratingStaticLabel: UILabel!
    
    private var viewModel: MovieViewModel?
    
    private lazy var allLabels: [UILabel?] = {
        [titleLabel,
        yearLabel,
        genresLabel,
        ratingLabel,
        genresStaticLabel,
        ratingStaticLabel]
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        movieImageView.addOverlay()
    }
    
    func setupWithViewModel(_ viewModel: MovieViewModel) {
        self.viewModel = viewModel
        setupUI()
        setupData()
    }
    
    private func setupUI() {
        setupTextAndBackground()
        
        genresLabel.preferredMaxLayoutWidth = 150
        genresLabel.numberOfLines = 3
        titleLabel.numberOfLines = 3

        movieImageView.layer.shadowColor = UIColor.black.cgColor
        movieImageView.layer.shadowRadius = 6
        movieImageView.layer.shadowOpacity = 1
        movieImageView.layer.shadowOffset = CGSize(width: 2, height: 1)
        movieImageView.layer.masksToBounds = false
        movieImageView.imageView.contentMode = .scaleAspectFill
        movieImageView.imageView.clipsToBounds = true
    }
    
    private func setupTextAndBackground() {
        for label in allLabels {
            label?.textColor = .white
            label?.font = .boldSystemFont(ofSize: 16)
        }
    }
    
    private func setupImageViewData() {
        if let url = viewModel?.smallImageUrl {
            movieImageView.placeholderView = UIActivityIndicatorView()
            movieImageView.priority = .veryHigh
            let imagePipeline = ImagePipeline(configuration: .withDataCache)
            movieImageView.pipeline = imagePipeline
            movieImageView.url = url
        } else {
            movieImageView.imageView.image = viewModel?.defaultImage
        }
    }
    
    private func setupData() {
        setupImageViewData()
        titleLabel.text = viewModel?.title
        yearLabel.text = viewModel?.year
        genresLabel.text = viewModel?.genres
        ratingLabel.text = viewModel?.rating
    }
}
