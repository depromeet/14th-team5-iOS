//
//  LottieProgressView.swift
//  BBProgressHUD
//
//  Created by 김건우 on 8/16/24.
//

import UIKit

public class LottieProgressHUDView: UIStackView, BBProgressHUDStackView {
    
    // MARK: - Views
    
    private let lottieView = BBLottieView(of: .airplane)
    private let titleLabel = BBLabel()
    
    
    // MARK: - Properties
        
    public let viewConfig: BBProgressHUDViewConfiguration
    public var progressHud: BBProgressHUD?
    
    private let kind: BBLottieKind
    
    
    // MARK: - Intializer
    
    public init(
        of kind: BBLottieKind,
        title: String? = nil,
        titleFontStyle: BBFontStyle? = nil,
        titleColor: UIColor? = nil,
        viewConfig: BBProgressHUDViewConfiguration
    ) {
        self.viewConfig = viewConfig
        self.kind = kind
        
        super.init(frame: .zero)
        commonInit()
        
        addArrangedSubview(lottieView)
        applyAnimation(for: lottieView)
        
        if let title = title {
            titleLabel.text = title
            titleLabel.fontStyle = titleFontStyle ?? .body1Regular
            titleLabel.textColor = titleColor ?? .bibbiWhite
            titleLabel.textAlignment = .center
            titleLabel.numberOfLines = 1
            addArrangedSubview(titleLabel)
        }
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        applyAnimation(for: lottieView)
    }
    
    
    // MARK: - Helpers
    
    private func commonInit() {
        axis = .vertical
        spacing = 6
        alignment = .fill
        distribution = .fillProportionally
    }
    
    private func applyAnimation(for view: BBLottieView) {

        view.contentMode = .scaleAspectFit
        view.animationSpeed = viewConfig.lottieAnimationSpeed
        view.transform = CGAffineTransform(
            scaleX: viewConfig.lottieAnimationScale,
            y: viewConfig.lottieAnimationScale
        )
        
        view.startAnimating(
            fromProgress: viewConfig.lottieFromProgress,
            toProgress: viewConfig.lottieToProgress,
            loopMode: .loop
        )
        
    }
    
}
