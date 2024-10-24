//
//  TabModel.swift
//  Movies
//
//  Created by Macbook on 22.10.2024.
//

import Foundation

protocol TabProtocol {
    var name: String { get }
    var iconName: String { get }
    var tagIndex: Int { get }
}

enum Tab: TabProtocol, CaseIterable, Identifiable {
    case home
    case favourites
    case settings
    
    var name: String {
        switch self {
        case .home:
            "Home"
        case .favourites:
            "Favourites"
        case .settings:
            "Settings"
        }
    }
    
    var iconName: String {
        switch self {
        case .home:
            "house.fill"
        case .favourites:
            "heart.fill"
        case .settings:
            "gearshape"
        }
    }
    
    var tagIndex: Int {
           switch self {
           case .home:
               0
           case .favourites:
               1
           case .settings:
               2
           }
       }
    
    var id: String {
        self.name
    }
}
