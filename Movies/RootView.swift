//
//  RootView.swift
//  Movies
//
//  Created by Macbook on 21.10.2024.
//

import SwiftUI
import Combine

struct RootView: View {
    
    @StateObject var tabsViewModel = TabsViewModel()
    @State var foldTabNavigation = false
    @State var homeView: HomeView // saving as @State to save scroll/navigation states
    var hideTabNavigationSub = PassthroughSubject<Bool, Never>()
    
    init() {
        _homeView = State(initialValue: HomeView(hideTabNavigationSub: hideTabNavigationSub))
    }
    
    var body: some View {
        ZStack {
            Group {
                switch tabsViewModel.selectedTab {
                case .home:
                    homeView
                case .favourites:
                    Text("Favourites Tab")
                case .settings:
                    SettingsView()
                }
            }
            .transition(.dynamicSlide(forward: $tabsViewModel.tabTransitionDirectionIsForward))
            .animation(.default, value: tabsViewModel.selectedTab)
            
            VStack {
                Spacer()
                TabsView(viewModel: tabsViewModel, isFolded: $foldTabNavigation)
                    .padding(.bottom)
            }
            
        }
        .ignoresSafeArea()
        .onReceive(hideTabNavigationSub) { hide in
            withAnimation() {
                foldTabNavigation = hide
            }
        }
        
    }
}

#Preview {
    RootView()
}
