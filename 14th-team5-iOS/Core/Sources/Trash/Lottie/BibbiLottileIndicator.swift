//
//  BibbiLoadIndicator.swift
//  Core
//
//  Created by geonhui Yu on 1/29/24.
//

import UIKit
import RxSwift
import RxCocoa
import Lottie

@available(*, deprecated, renamed: "BBProgressHUD")
public class BibbiLoadIndicator {
    private var disposeBag = DisposeBag()
    
    // MARK: Actions
    let startLoad = PublishRelay<LottieType>()
    let finishLoad = PublishRelay<LottieType>()
    private var isLoading = BehaviorRelay<Bool>(value: false)
    
    // MARK: Loading Node
    private lazy var loadingView = LottieView().then {
        $0.frame = UIScreen.main.bounds
        $0.isHidden = false
    }
    
    public func bind() {
        let started = self.startLoad
            .withLatestFrom(self.isLoading, resultSelector: { ($0, $1) })
            .filter { !$0.1 }
            .do(onNext: { [weak self] in self?.isLoading.accept(!$0.1) })
            .withLatestFrom(self.isLoading, resultSelector: { ($0.0, $1) })
            .filter { $0.1 }.map { $0.0 }
        
        started
            .observe(on: MainScheduler.instance)
            .debug("Show load indicator")
//            .filter { _ in
//                if let keyWindowScene = UIApplication.shared.connectedScenes
//                    .compactMap({ $0 as? UIWindowScene })
//                    .first(where: { $0.activationState == .foregroundActive }),
//                   let _ = keyWindowScene.windows.first(where: { $0.isKeyWindow }) {
//                    return true
//                } else {
//                    return false
//                }
//            }
            .map { ($0, UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }).first?.windows.first(where: { $0.isKeyWindow })!) }
            .do(onNext: { [weak self] in self?.loadingView.showLottieView.accept($0.0) })
            .map({ $0.1! })
            .bind(onNext: { [weak self] window in
                guard let self = self, self.loadingView.superview == nil else { return }
                
                self.loadingView.frame = window.bounds
                window.addSubview(self.loadingView)
            })
            .disposed(by: self.disposeBag)
        
        self.finishLoad
            .observe(on: MainScheduler.instance)
            .bind(onNext: { [weak self] kind in
                self?.isLoading.accept(false)
                self?.loadingView.removeFromSuperview()
            })
            .disposed(by: self.disposeBag)
    }
    
    public func unbind() {
        self.disposeBag = DisposeBag()
    }
    
    // MARK: Show & Hide
    public func show(with kind: LottieType) {
        self.startLoad.accept(kind)
    }

    public func hide(with kind: LottieType) {
        self.finishLoad.accept(kind)
    }
}
