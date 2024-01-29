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

final public class LottieView: UIView {
    // MARK: SubView
    private lazy var animationView = LottieAnimationView()
    
    // MARK: Property
    let showLottieView = PublishRelay<LottieType>()
    
    var kind: LottieType? = .loading {
        didSet {
            guard let kind else { return }
            let animation = LottieAnimation.named(kind.key)
            animationView.animation = animation
            animationView.backgroundBehavior = .pause
            animationView.loopMode = .loop
        }
    }
    
    public convenience init(kind: LottieType) {
        self.init(frame: .zero)
        self.kind = kind
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupUI()
        self.setupAutoLayout()
        self.setupAttributes()
        
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
    
    private func setupAttributes() {
        animationView.do {
            guard let kind = kind else { return }
            let animation = LottieAnimation.named(kind.key)
            $0.animation = animation
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
    
    public func stop() {
        self.isHidden = true
    }
    
    public func play() {
        self.isHidden = false
    }
    
    private func showLottieView(_ kind: LottieType) {
        debugPrint(#function)
        let animation = LottieAnimation.named(kind.key)
        animationView.animation = animation
        animationView.backgroundBehavior = .pause
        animationView.loopMode = .loop
    }
}
