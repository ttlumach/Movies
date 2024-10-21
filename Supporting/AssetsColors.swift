//
//  Colors.swift
//  AssetsColora
//
//  Created by Macbook on 24.07.2024.
//

import UIKit
import SwiftUI

enum AssetsColor {
    case primaryText
    case secondaryText
    case background
    case secondaryBackground
    case tertiaryBackground
    case highlightedText
    case navigationBarText
    case navigationBarBackground
}

extension UIColor {

    static func appColor(_ name: AssetsColor) -> UIColor? {
        switch name {
        case .primaryText:
            return UIColor(named: "PrimaryText")
        case .secondaryText:
            return UIColor(named: "SecondaryText")
        case .background:
            return UIColor(named: "Background")
        case .secondaryBackground:
            return UIColor(named: "SecondaryBackground")
        case .tertiaryBackground:
            return UIColor(named: "TertiaryBackground")
        case .highlightedText:
            return UIColor(named: "Highlights")
        case .navigationBarBackground:
            return UIColor(named: "NavigationBarBackground")
        case .navigationBarText:
            return UIColor(named: "NavigationBarText")
        }
    }
}

extension Color {
    static func appColor(_ name: AssetsColor) -> Color {
        switch name {
        case .primaryText:
            return Color("PrimaryText")
        case .secondaryText:
            return Color("SecondaryText")
        case .background:
            return Color("Background")
        case .secondaryBackground:
            return Color("SecondaryBackground")
        case .tertiaryBackground:
            return Color("TertiaryBackground")
        case .highlightedText:
            return Color("Highlights")
        case .navigationBarText:
            return Color("NavigationBarText")
        case .navigationBarBackground:
            return Color("NavigationBarBackground")
        }
    }
}
