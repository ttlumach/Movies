//
//  UIViewControllerWithSpinner.swift
//  Movies
//
//  Created by Macbook on 15.07.2024.
//

import UIKit

class UIViewControllerWithSpinner: UIViewController {
    
    var spinnerVC = SpinnerViewController()
    
    func startSpinner() {
        addChild(spinnerVC)
        spinnerVC.view.frame = view.frame
        view.addSubview(spinnerVC.view)
        spinnerVC.didMove(toParent: self)
    }
    
    func stopSpinner() {
        spinnerVC.willMove(toParent: nil)
        spinnerVC.view.removeFromSuperview()
        spinnerVC.removeFromParent()
    }
}
