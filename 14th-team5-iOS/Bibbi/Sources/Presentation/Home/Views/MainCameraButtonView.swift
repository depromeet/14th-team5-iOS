//
//  CameraButtonView.swift
//  App
//
//  Created by 마경미 on 30.04.24.
//

import UIKit

import Core
import Domain
import DesignSystem

import RxSwift
import RxCocoa

final class MainCameraButtonView: BaseView<MainCameraReactor> {
    private let balloonView: BalloonView = BalloonView(reactor: BalloonReactor())
    private let cameraButton: UIButton = UIButton()
    
    let textRelay: BehaviorRelay<BalloonText> = BehaviorRelay(value: .survivalStandard)
    let cameraEnabledRelay: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    var camerTapEvent: ControlEvent<Void> {
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
        textRelay.map { Reactor.Action.setText($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: MainCameraReactor) {
        reactor.state.map { $0.balloonText.message }
            .bind(to: balloonView.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.balloonText.balloonType }
            .bind(to: balloonView.balloonTypeRelay)
            .disposed(by: disposeBag)
        
        cameraEnabledRelay
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind(onNext: {
                $0.0.alpha = $0.1 ? 1 : 0.5
                $0.0.isUserInteractionEnabled = $0.1
            })
            .disposed(by: disposeBag)
    }
}
