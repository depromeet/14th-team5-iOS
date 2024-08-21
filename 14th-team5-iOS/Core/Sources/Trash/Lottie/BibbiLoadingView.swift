//
//  BibbiLoadingView.swift
//  Core
//
//  Created by Kim dohyun on 1/31/24.
//

import UIKit

import Lottie

@available(*, deprecated, renamed: "BBLottieView")
public final class BibbiLoadingView: UIView {
    
    public let loadingView: LottieAnimationView = LottieAnimationView()
    public var loadingWindowView: UIWindow?
    
    public var kind: LottieType? = .loading {
        didSet {
            guard let kind else { return }
            let animation = LottieAnimation.named(kind.key)
            loadingView.animation = animation
            loadingView.backgroundBehavior = .pause
            loadingView.loopMode = .loop
        }
    }
    
    public override var isHidden: Bool {
        didSet {
            if self.isHidden {
                self.hide()
            } else {
                self.show()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        print("CommonView Size: \(UIScreen.main.bounds)")
        setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeWindow() -> UIWindow? {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .last { $0.isKeyWindow }
    }
    
    
    
    private func makeLoadingView() {
        guard let window = makeWindow() else { return }
        loadingWindowView = window
        loadingView.frame = loadingWindowView?.bounds ?? .zero
        
        window.addSubview(loadingView)
        
        loadingView.snp.makeConstraints {
            $0.width.height.equalTo(50)
            $0.center.equalToSuperview()
        }
        
    }
    
    private func setupAttributes() {
        loadingView.do {
            guard let kind = kind else { return }
            let animation = LottieAnimation.named(kind.key)
            $0.animation = animation
            $0.backgroundBehavior = .pause
            $0.loopMode = .loop
        }
        
    }
    
    private func show() {
        makeLoadingView()
        loadingWindowView?.isUserInteractionEnabled = false
        loadingView.play()
    }
    
    private func hide() {
        loadingView.stop()
        loadingWindowView?.isUserInteractionEnabled = true
        loadingView.removeFromSuperview()
    }
    
    
    
}
