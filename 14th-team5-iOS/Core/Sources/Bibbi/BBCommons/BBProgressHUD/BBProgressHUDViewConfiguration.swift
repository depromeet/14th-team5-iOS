//
//  BBProgressHUDViewConfiguration.swift
//  BBProgressHUD
//
//  Created by 김건우 on 8/16/24.
//

import UIKit

public struct BBProgressHUDViewConfiguration {
    
    // MARK: - Properties
    
    public let minWidth: CGFloat
    public let minHeight: CGFloat
    
    public let xOffset: CGFloat
    public let yOffset: CGFloat
    
    public let animationColor: UIColor?
    public let backgroundColor: UIColor?
    
    public let lottieFromProgress: CGFloat
    public let lottieToProgress: CGFloat
    public let lottieAnimationSpeed: CGFloat
    public let lottieAnimationScale: CGFloat
    
    public let cornerRadius: CGFloat?
    
    
    // MARK: - Intializer
    
    public init(
        minWidth: CGFloat = 130,
        minHeight: CGFloat = 130,
        offsetFromCenterX xOffset: CGFloat = 0,
        offsetFromCenterY yOffset: CGFloat = 0,
        animationColor: UIColor? = .mainYellow,
        backgroundColor: UIColor? = .gray900,
        lottieFromProgress fromProgress: CGFloat = 0,
        lottieToProgress toProgress: CGFloat = 1,
        lottieAnimationSpeed speed: CGFloat = 1,
        lottieAnimationScale scale: CGFloat = 1,
        cornerRadius: CGFloat? = 30
    ) {
        self.minWidth = minWidth
        self.minHeight = minHeight
        self.xOffset = xOffset
        self.yOffset = yOffset
        self.animationColor = animationColor
        self.backgroundColor = backgroundColor
        self.lottieFromProgress = fromProgress
        self.lottieToProgress = toProgress
        self.lottieAnimationSpeed = speed
        self.lottieAnimationScale = scale
        self.cornerRadius = cornerRadius
    }
    
}


// MARK: - Extensions

public extension BBProgressHUDViewConfiguration {
    
    static var lottie: Self = {
        Self(
            lottieFromProgress: 0.15,
            lottieToProgress: 0.95,
            lottieAnimationSpeed: 1.35,
            lottieAnimationScale: 1.1
        )
    }()
    
    static var lottieWithTitle: Self = {
        Self(
            minWidth: 160,
            minHeight: 160,
            backgroundColor: .clear,
            lottieFromProgress: 0.15,
            lottieToProgress: 0.95,
            lottieAnimationSpeed: 1.35,
            lottieAnimationScale: 1.1
        )
    }()
    
}
