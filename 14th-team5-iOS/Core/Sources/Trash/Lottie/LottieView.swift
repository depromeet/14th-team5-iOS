//
//  LottieView.swift
//  App
//
//  Created by geonhui Yu on 1/29/24.
//

import UIKit
import Lottie
import SnapKit
import RxSwift
import RxCocoa

@available(*, deprecated, renamed: "BBLottieView")
final public class LottieView: UIView {
  
    // MARK: SubView
    private lazy var animationView = LottieAnimationView()
    
    // MARK: Property
    let showLottieView = PublishRelay<LottieType>()
    
  
    var kind: LottieType?
    
    public convenience init(
        with kind: LottieType = .loading,
        contentMode: UIView.ContentMode = .scaleAspectFit
    ) {
        self.init(frame: .zero)
        self.setupUI()
        self.setupAutoLayout()
        self.setupAttributes(with: kind, contentMode: contentMode)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.showLottieView
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { $0.0.showLottieView($0.1) })
            .disposed(by: DisposeBag())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubviews(animationView)
    }
    
    private func setupAutoLayout() {
        animationView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.verticalEdges.equalToSuperview()
        }
    }
    
    private func setupAttributes(with kind: LottieType?, contentMode: UIView.ContentMode) {
        animationView.do {
            guard let kind else { return }
            let animation = LottieAnimation.named(kind.key)
            animationView.animation = animation
            animationView.contentMode = contentMode
            $0.backgroundBehavior = .pause
            $0.loopMode = .loop
        }
    }
    
    public override var isHidden: Bool {
        didSet {
            if self.isHidden {
                self.animationView.stop()
            } else {
                self.animationView.play()
            }
        }
    }

    public var isPlay: Bool {
        return !self.isHidden
    }
    
    public func stop() {
        self.isHidden = true
    }
    
    public func play() {
        self.isHidden = false
    }
    
    private func showLottieView(_ kind: LottieType) {
        let animation = LottieAnimation.named(kind.key)
        animationView.animation = animation
        animationView.backgroundBehavior = .pause
        animationView.loopMode = .loop
    }
}
