//
//  Shimmer.swift
//  Core
//
//  Created by 김건우 on 5/20/24.
//

import Foundation
import SwiftUI

public struct Shimmer: ViewModifier {
    private let animation: Animation
    private let gradient: Gradient
    private let min, max: CGFloat
    @State private var isIntialState = true
    @Environment(\.layoutDirection) private var layoutDirection
    
    init(
        animation: Animation = Self.defaultAnimation,
        gradient: Gradient = Self.defaultGradient,
        bandSize: CGFloat = 0.3
    ) {
        self.animation = animation
        self.gradient = gradient
        self.min = 0 - bandSize
        self.max = 1 + bandSize
    }
    
    public static let defaultAnimation = Animation.linear(duration: 1.5).delay(0.25).repeatForever(autoreverses: false)
    
    public static let defaultGradient = Gradient(colors: [
        Color.black.opacity(0.3),
        Color.black,
        Color.black.opacity(0.3)
    ])
    
    /*
     Calculating the gradient's animated start and end unit points:
     min,min
        \
         ┌───────┐         ┌───────┐
         │0,0    │ Animate │       │  "forward" gradient
     LTR │       │ ───────►│    1,1│  / // /
         └───────┘         └───────┘
                                    \
                                  max,max
                max,min
                  /
         ┌───────┐         ┌───────┐
         │    1,0│ Animate │       │  "backward" gradient
     RTL │       │ ───────►│0,1    │  \ \\ \
         └───────┘         └───────┘
                          /
                       min,max
    */
    
    var startPoint: UnitPoint {
        if layoutDirection == .rightToLeft {
            return isIntialState ? UnitPoint(x: max, y: min) : UnitPoint(x: 0, y: 1)
        } else {
            return isIntialState ? UnitPoint(x: min, y: min) : UnitPoint(x: 1, y: 1)
        }
    }
    
    var endPoint: UnitPoint {
        if layoutDirection == .rightToLeft {
            return isIntialState ? UnitPoint(x: 1, y: 0) : UnitPoint(x: min, y: max)
        } else {
            return isIntialState ? UnitPoint(x: 0, y: 0) : UnitPoint(x: max, y: max)
        }
    }
    
    public func body(content: Content) -> some View {
        content
            .mask(LinearGradient(gradient: gradient, startPoint: startPoint, endPoint: endPoint))
            .animation(animation, value: isIntialState)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    isIntialState = false
                }
            }
    }
}

// MARK: - Extensions
public extension View {
    @ViewBuilder
    func shimmering(
        active: Bool = true,
        animation: Animation = Shimmer.defaultAnimation,
        gradient: Gradient = Shimmer.defaultGradient,
        bandSize: CGFloat = 0.3
    ) -> some View {
        if active {
            modifier(Shimmer(animation: animation, gradient: gradient, bandSize: bandSize))
        } else {
            self
        }
    }
}
