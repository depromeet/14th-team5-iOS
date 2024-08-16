//
//  LottieProgressView.swift
//  BBProgressHUD
//
//  Created by 김건우 on 8/16/24.
//

import UIKit

public class LottieProgressHUDView: UIView, BBProgressHUDSubView {
    
    // MARK: - Properties
    
    private let kind: BBLottieKind
    
    public let viewConfig: BBProgressHUDViewConfiguration
    
    // MARK: - Intializer
    
    public init(
        of kind: BBLottieKind,
        viewConfig: BBProgressHUDViewConfiguration
    ) {
        self.viewConfig = viewConfig
        self.kind = kind
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helpers
    
    public func applyAnimation(for progressHud: BBProgressHUD?) {

        let lottieView = BBLottieView(of: kind)
        addSubview(lottieView)
        
        lottieView.frame = self.bounds
        lottieView.contentMode = .scaleAspectFit
        lottieView.animationSpeed = viewConfig.lottieAnimationSpeed
        lottieView.transform = CGAffineTransform(
            scaleX: viewConfig.lottieAnimationScale,
            y: viewConfig.lottieAnimationScale
        )
        
        lottieView.startAnimating(
            fromProgress: viewConfig.lottieFromProgress,
            toProgress: viewConfig.lottieToProgress,
            loopMode: .loop
        )
        
    }
    
}
