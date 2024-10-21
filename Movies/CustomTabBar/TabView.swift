//
//  TabView.swift
//  Movies
//
//  Created by Macbook on 21.10.2024.
//

import SwiftUI

enum Tab: String {
    case home = "Home"
    case favourites = "Favourites"
    case settings = "Settings"
}

struct TabsView: View {
    
    struct TabBarItem: Identifiable {
        var id = UUID()
        var iconName: String
        var tagIndex: Int
        var tab: Tab
    }
    
    let tabButtonHeight: CGFloat = 35
    let tabBarHeight: CGFloat = 70
    let tabBarWidth: CGFloat = 350
    
    // If you will add more or less than 3 tabs you must change this vars
    let customShapeOffset: CGFloat = 40
    let customCircleOffset: CGFloat = 64
    let tabBarCornerRadius: CGFloat = 12
    let offsetMultiplier: Int = 105
    
    @Binding var selectedTab: Tab
    @State var offsetX: CGFloat = 0
    
    @State var tabItems = [
        TabBarItem(iconName: "house.fill", tagIndex: 0, tab: .home),
        TabBarItem(iconName: "heart.fill", tagIndex: 1, tab: .favourites),
        TabBarItem(iconName: "gearshape", tagIndex: 2, tab: .settings)
    ]
    
    var body: some View {
        Spacer()
        HStack {
            ForEach(tabItems) { item in
                Spacer()
                Image(systemName: item.iconName)
                    .foregroundStyle(selectedTab == item.tab ? Color.appColor(.highlightedText) : Color.appColor(.navigationBarText))
                    .onTapGesture {
                        withAnimation(.easeOut) {
                            selectedTab = item.tab
                            offsetX = CGFloat(item.tagIndex * offsetMultiplier)
                        }
                    }
                Spacer()
            }
            .frame(width: tabButtonHeight)
        }
        .frame(width: tabBarWidth, height: tabBarHeight)
        .background(
            CustomShape(xAxis: offsetX + customShapeOffset)
                .fill(Color.appColor(.navigationBarBackground))
                .clipShape(.rect(cornerRadius: tabBarCornerRadius))
        )
        .overlay(alignment: .topLeading) {
            Circle()
                .fill(Color.appColor(.navigationBarBackground))
                .frame(width: 10, height: 10)
                .offset(x: customCircleOffset)
                .offset(x: offsetX)
        }
    }
    
}

#Preview {
    TabsView(selectedTab: .constant(.home))
}
