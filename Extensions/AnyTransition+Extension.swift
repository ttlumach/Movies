//
//  AnyTransition+Extension.swift
//  Movies
//
//  Created by Macbook on 22.10.2024.
//

import SwiftUI

extension AnyTransition {
    
    struct SlideModifier: ViewModifier {
        let width: CGFloat
        @Binding var forward: Bool

        func body(content: Content) -> some View {
            content
                .offset(x: (forward ? 1 : -1) * width)
        }
    }

    static func dynamicSlide(forward: Binding<Bool>) -> AnyTransition {
        return .asymmetric(
            insertion: .modifier(
                active: SlideModifier(width: UIScreen.main.bounds.width, forward: forward),
                identity: SlideModifier(width: 0, forward: .constant(true))
            ),

            removal: .modifier(
                active: SlideModifier(width: -UIScreen.main.bounds.width, forward: forward),
                identity: SlideModifier(width: 0, forward: .constant(true))
            )
        )
    }
}
