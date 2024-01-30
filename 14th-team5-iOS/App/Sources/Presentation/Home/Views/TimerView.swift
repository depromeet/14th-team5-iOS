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
    private let timerLabel: BibbiLabel = BibbiLabel(.head1, alignment: .center)
    private let descriptionLabel: BibbiLabel = BibbiLabel(.body2Regular, alignment: .center, textColor: .gray300)
    private let imageView: UIImageView = UIImageView()
  
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
        setupAutoLayout()
        setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func bind(reactor: TimerReactor) {
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    override func setupUI() {
        addSubviews(dividerView, timerLabel, descriptionLabel, imageView)
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
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(timerLabel.snp.bottom).offset(8)
            $0.height.equalTo(20)
            $0.centerX.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel)
            $0.size.equalTo(20)
            $0.leading.equalTo(descriptionLabel.snp.trailing).offset(2)
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
        reactor.state.map { $0.timerType }
            .distinctUntilChanged()
            .withUnretained(self)
            .observe(on: Schedulers.main)
            .bind(onNext: { $0.0.setCell(type: $0.1) })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.time }
            .distinctUntilChanged()
            .observe(on: Schedulers.main)
            .map { $0.setTimerFormat() }
            .bind(to: timerLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

extension TimerView {
    private func setCell(type: TimerType) {
        if type == .standard {
            descriptionLabel.text = "매일 12-24시에 사진 한 장을 올려요"
            descriptionLabel.textBibbiColor = .gray300
            timerLabel.textBibbiColor = .white
            imageView.image = DesignSystemAsset.smile.image
        } else if type == .warning {
            descriptionLabel.text = "시간이 얼마 남지 않았어요!"
            descriptionLabel.textBibbiColor = .warningRed
            timerLabel.textBibbiColor = .warningRed
            imageView.image = DesignSystemAsset.fire.image
        } else {
            descriptionLabel.text = "우리 가족 모두가 사진을 올린 날"
            descriptionLabel.textBibbiColor = .gray300
            timerLabel.textBibbiColor = .white
            imageView.image = DesignSystemAsset.congratulation.image
        }
    }
}
