//
//  Colors.swift
//  AssetsColora
//
//  Created by Macbook on 24.07.2024.
//

import UIKit

enum AssetsColor {
   case primaryText
   case secondaryText
   case background
   case secondaryBackground
   case tertiaryBackground
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
        }
    }
}
