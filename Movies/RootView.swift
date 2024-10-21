//
//  RootView.swift
//  Movies
//
//  Created by Macbook on 21.10.2024.
//

import SwiftUI

struct RootView: View {
    
    @State var selectedTab: Tab = .home
    
    var body: some View {
        ZStack {
            switch selectedTab {
            case .home:
                HomeView()
            case .favourites:
                Text("Favourites Tab")
            case .settings:
                SettingsView()
            }
            
            VStack {
                Spacer()
                TabsView(selectedTab: $selectedTab)
                    .padding(.bottom)
            }
        }
        .ignoresSafeArea()
        
    }
}

#Preview {
    RootView()
}
