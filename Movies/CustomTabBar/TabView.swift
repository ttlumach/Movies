//
//  TabView.swift
//  Movies
//
//  Created by Macbook on 21.10.2024.
//

import SwiftUI

struct TabsView: View {
    
    let tabButtonWidth: CGFloat = 35
    let tabBarHeight: CGFloat = 70
    let tabBarWidth: CGFloat = 350
    
    let foldedTabBarHeight: CGFloat = 35
    let foldedTabBarWidth: CGFloat = 50
    
    // If you will add more or less than 3 tabs you must change this vars
    let customShapeOffset: CGFloat = 40
    let customCircleOffset: CGFloat = 64
    let tabBarCornerRadius: CGFloat = 12
    let offsetMultiplier: Int = 105
    
    @State var offsetX: CGFloat = 0
    @ObservedObject var viewModel: TabsViewModel
    @Binding var isFolded: Bool
    
    var body: some View {
        Spacer()
        if !isFolded {
            HStack {
                ForEach(Tab.allCases) { tab in
                    Spacer()
                    Image(systemName: tab.iconName)
                        .foregroundStyle(viewModel.selectedTab.tagIndex == tab.tagIndex ? Color.appColor(.highlightedText) : Color.appColor(.navigationBarText))
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                viewModel.selectedTab = tab
                                offsetX = CGFloat(tab.tagIndex * offsetMultiplier)
                            }
                        }
                    Spacer()
                }
                .frame(width: tabButtonWidth)
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
            .transition(
                .asymmetric(insertion: .move(edge: .bottom).animation(.default.delay(1)),
                            removal: .move(edge: .bottom)))
        } else {
            HStack {
                Spacer()
                Image(systemName: "chevron.up")
                    .foregroundStyle(Color.appColor(.navigationBarText))
                    .frame(width: foldedTabBarWidth, height: foldedTabBarHeight)
                    .background(
                        Rectangle()
                            .fill(Color.appColor(.navigationBarBackground))
                            .clipShape(.rect(cornerRadius: tabBarCornerRadius))
                    )
                    .padding(.trailing)
            }
            .onTapGesture {
                withAnimation(.easeIn) {
                    isFolded.toggle()
                }
            }
            .transition(
                .asymmetric(
                    insertion: .move(edge: .bottom).animation(.default.delay(5)),
                    removal: .move(edge: .bottom)
                )
            )
        }
    }
    
}


#Preview {
    TabsView(viewModel: TabsViewModel(), isFolded: .constant(false))
}
