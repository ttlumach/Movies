//
//  UIViewControllerWithSpinner.swift
//  Movies
//
//  Created by Macbook on 15.07.2024.
//

import UIKit

class UIViewControllerWithSpinner: UIViewController {
    
    private var spinnerVC = SpinnerViewController()
    
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


private class SpinnerViewController: UIViewController {
    private var spinner = UIActivityIndicatorView(style: .large)

    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.5)

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
