//
//  HomeMovieTableViewCellModel.swift
//  Movies
//
//  Created by Macbook on 04.07.2024.
//

import UIKit

class HomeMovieTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var genresLabel: UILabel!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var movieImageView: UIImageView!
    
    @IBOutlet var genresStaticLabel: UILabel!
    @IBOutlet var ratingStaticLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupUI(movieTitle: String, moviewYear: String, genres: String, rating: String, image: UIImage) {
        self.titleLabel.text = movieTitle
        self.yearLabel.text = moviewYear
        self.genresLabel.text = genres
        self.ratingLabel.text = rating
        self.movieImageView.image = image
        
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
