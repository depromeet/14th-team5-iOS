//
//  CameraButtonView.swift
//  App
//
//  Created by 마경미 on 30.04.24.
//

import UIKit

import Core
import DesignSystem

import RxSwift
import RxCocoa

final class MainCameraButtonView: BaseView<MainCameraReactor> {
    private let balloonView: BalloonView = BalloonView()
    private let cameraButton: UIButton = UIButton()
    
    let indexRelay: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    var camerTapObservable: ControlEvent<Void> {
        return cameraButton.rx.tap
    }
    
    override func bind(reactor: MainCameraReactor) {
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    override func setupUI() {
        addSubviews(balloonView, cameraButton)
    }
    
    override func setupAutoLayout() {
        balloonView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(cameraButton.snp.top).offset(-8)
            $0.height.equalTo(52)
        }
        
        cameraButton.snp.makeConstraints {
            $0.size.equalTo(HomeAutoLayout.CamerButton.size)
            $0.centerX.bottom.equalToSuperview()
        }
    }
    
    override func setupAttributes() {
        cameraButton.do {
            $0.setImage(DesignSystemAsset.shutter.image, for: .normal)
        }
    }
}

extension MainCameraButtonView {
    private func bindInput(reactor: MainCameraReactor) {
        indexRelay
            .map { Reactor.Action.getType($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: MainCameraReactor) {
        reactor.state.map { $0.balloonText.rawValue }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(to: balloonView.text)
            .disposed(by: disposeBag)
    }
}
