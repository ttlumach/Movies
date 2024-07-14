//
//  MovieAdditionalDetailsView.swift
//  Movies
//
//  Created by Macbook on 13.07.2024.
//

import Foundation
import UIKit
import SnapKit

class MovieAdditionalDetailsVC: UIViewController {
    
    weak var viewModel: MoviesViewModel?
    
    var movieImageView = UIImageView()
    var titleLabel = UILabel()
    var yearAndCountryLabel = UILabel()
    var genresLabel = UILabel()
    var ratingLabel = UILabel()
    var trailerButton = UIButton()
    var overviewLabel = UILabel()
    
    override func viewDidLoad() {
        setupUI()
        setupData()
    }
    
    private func setupUI() {
        view.addSubview(movieImageView)
        movieImageView.snp.makeConstraints { make in
            make.height.equalTo(600)
            make.trailing.leading.top.equalToSuperview()
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(movieImageView.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(5)
        }
        
        view.addSubview(yearAndCountryLabel)
        yearAndCountryLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(5)
        }
        
        view.addSubview(genresLabel)
        genresLabel.snp.makeConstraints { make in
            make.top.equalTo(yearAndCountryLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(5)
        }
        genresLabel.numberOfLines = 3
        
        view.addSubview(trailerButton)
        trailerButton.snp.makeConstraints { make in
            make.top.equalTo(genresLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(5)
        }
        
        view.addSubview(ratingLabel)
        ratingLabel.snp.makeConstraints { make in
            make.centerY.equalTo(trailerButton.snp.centerY)
            make.trailing.equalToSuperview().offset(5)
        }
        
        view.addSubview(overviewLabel)
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(trailerButton.snp.bottom).offset(10)
            make.trailing.leading.equalToSuperview().offset(5)
        }
    }
    
    private func setupData() {
        
    }
}
