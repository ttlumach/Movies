//
//  SettingsView.swift
//  Movies
//
//  Created by Macbook on 21.10.2024.
//

import SwiftUI

struct SettingsView: UIViewControllerRepresentable {

    typealias UIViewControllerType = UINavigationController

    func makeUIViewController(context: Context) -> UINavigationController {
        UINavigationController(rootViewController: SettingsViewController())
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
       
    }
}
