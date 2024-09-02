//
//  TimerCollectionViewCell.swift
//  App
//
//  Created by 마경미 on 30.01.24.
//

import UIKit

import Core
import DesignSystem

import ReactorKit
import RxSwift

final class TimerView: BaseView<TimerReactor> {
    private let dividerView: UIView = UIView()
    private let timerLabel: BBLabel = BBLabel(.head1, textAlignment: .center)
  
    override func bind(reactor: TimerReactor) {
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    override func setupUI() {
        addSubviews(dividerView, timerLabel)
    }
    
    override func setupAutoLayout() {
        dividerView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        timerLabel.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(24)
        }
    }
    
    override func setupAttributes() {
        dividerView.do {
            $0.backgroundColor = .gray900
        }
    }
}

extension TimerView {
    private func bindInput(reactor: TimerReactor) {
        Observable.just(())
            .map { TimerReactor.Action.startTimer }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: TimerReactor) {
        reactor.pulse(\.$time)
            .distinctUntilChanged()
            .observe(on: RxSchedulers.main)
            .map { $0.setTimerFormat() }
            .bind(to: timerLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.timerType }
            .distinctUntilChanged()
            .map { return $0 == .standard ? .gray100 : .warningRed }
            .bind(to: timerLabel.rx.textColor)
            .disposed(by: disposeBag)
    }
}
