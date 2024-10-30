//
//  TabsViewModel.swift
//  Movies
//
//  Created by Macbook on 22.10.2024.
//

import SwiftUI
import Combine

class TabsViewModel: ObservableObject {
    
    @Published var selectedTab: Tab = Tab.home
    @Published var tabTransitionDirectionIsForward: Bool = true
    
    init() {
        $selectedTab
            .map {
                print("tab value now: \(self.selectedTab)")
                print("next tab is: \($0)")
                return self.selectedTab.tagIndex < $0.tagIndex
            }
            .assign(to: &$tabTransitionDirectionIsForward)
    }
}
