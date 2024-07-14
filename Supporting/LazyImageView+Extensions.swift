//
//  ImageView+Extensions.swift
//  Movies
//
//  Created by Macbook on 14.07.2024.
//

import Foundation
import UIKit
import NukeUI

extension LazyImageView {
func addOverlay(color: UIColor = .black, alpha : CGFloat = 0.5) {
    let overlay = UIView()
    overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    overlay.frame = bounds
    overlay.backgroundColor = color
    overlay.alpha = alpha
    addSubview(overlay)
    }
    //This function will add a layer on any `UIView` to make that `UIImageView` look darkened
}
