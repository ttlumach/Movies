//
//  CustomShape.swift
//  Movies
//
//  Created by Macbook on 21.10.2024.
//

import Foundation
import SwiftUI

struct TabBarShape: View {
    @Binding var xAxis: CGFloat
    var body: some View {
        ZStack {
            CustomShape(xAxis: xAxis)
                .foregroundStyle(.pink)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .padding(.vertical)
                .frame(width: 350, height: 100, alignment: .center)
        }
    }
}

struct CustomShape: Shape {
    var xAxis: CGFloat
    var animatableData: CGFloat {
        get { xAxis }
        set { xAxis = newValue }
    }

    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))

            let center = xAxis + 30

            path.move(to: CGPoint(x: center - 35, y: 0))

            let to1 = CGPoint(x: center, y: 16)
            let control1 = CGPoint(x: center - 12, y: 0)
            let control2 = CGPoint(x: center - 12, y: 15)

            let to2 = CGPoint(x: center + 30, y: 0)
            let control3 = CGPoint(x: center + 12, y: 15)
            let control4 = CGPoint(x: center + 12, y: 0)

            path.addCurve(to: to1, control1: control1, control2: control2)
            path.addCurve(to: to2, control1: control3, control2: control4)
        }
    }
}

