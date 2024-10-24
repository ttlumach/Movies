//
//  View+Extension.swift
//  Movies
//
//  Created by Macbook on 22.10.2024.
//

import SwiftUI

extension View {
    func hidden(_ shouldHide: Bool) -> some View {
        opacity(shouldHide ? 0 : 1)
    }
}
