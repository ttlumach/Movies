//
//  HomeView.swift
//  Movies
//
//  Created by Macbook on 21.10.2024.
//

import SwiftUI

struct HomeView: UIViewControllerRepresentable {

    typealias UIViewControllerType = UINavigationController

    func makeUIViewController(context: Context) -> UINavigationController {
        UINavigationController(rootViewController: HomeViewController())
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        
    }
}

