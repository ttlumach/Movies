//
//  HomeView.swift
//  Movies
//
//  Created by Macbook on 21.10.2024.
//

import SwiftUI
import Combine

struct HomeView: UIViewControllerRepresentable {

    typealias UIViewControllerType = UINavigationController
    
    var viewController = HomeViewController()
    var hideTabNavigationSub: PassthroughSubject<Bool, Never>

    func makeUIViewController(context: Context) -> UINavigationController {
        
        viewController.hideTabNavigationSub = hideTabNavigationSub
        
        return UINavigationController(rootViewController: viewController)
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        
    }
}

