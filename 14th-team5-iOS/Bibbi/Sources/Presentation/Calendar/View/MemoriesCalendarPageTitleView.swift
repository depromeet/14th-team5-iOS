//
//  MemoriesCalendarPageHeaderView.swift
//  App
//
//  Created by 김건우 on 10/16/24.
//

import Core
import DesignSystem
import UIKit

import SnapKit
import Then

final public class MemoriesCalendarPageTitleView: BaseView<MemoriesCalendarTitleViewReactor> {
    
    // MARK: - Views
    
    private let labelStack: UIStackView = UIStackView()
    private let titleLabel: BBLabel = BBLabel(.head2Bold, textAlignment: .center, textColor: .gray200)
    private let memoryCountLabel: BBLabel = BBLabel(.body1Regular, textColor: .gray200)
    private let tipButton: UIButton = UIButton(type: .system)
    
    private let toolTipView: BBToolTip = BBToolTip(.monthlyCalendar)
    
    // MARK: - Properties
    
    private let tipImage: UIImage = DesignSystemAsset.infoCircleFill.image.withRenderingMode(.alwaysTemplate)
    
    
    // MARK: - Helpers
    
    public override func bind(reactor: Reactor) {
        super.bind(reactor: reactor)
        
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: Reactor) {
        tipButton.rx.tap
            .throttle(RxInterval._300milliseconds, scheduler: RxScheduler.main)
            .map { Reactor.Action.didTapTipButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: Reactor) {
        reactor.pulse(\.$hiddenTooltipView)
            .bind(to: toolTipView.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    
    public override func setupUI() {
        super.setupUI()
        
        self.addSubviews(labelStack, memoryCountLabel)
        labelStack.addArrangedSubviews(titleLabel, tipButton)
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        
        labelStack.snp.makeConstraints {
            $0.top.equalToSuperview().offset(0)
            $0.leading.equalToSuperview().offset(0)
        }
        
        memoryCountLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(0)
            $0.trailing.equalToSuperview().offset(0)
        }
        
        tipButton.snp.makeConstraints {
            $0.size.equalTo(20)
        }
        
    }

    public override func setupAttributes() {
        super.setupAttributes()
        
        self.clipsToBounds = false
        
        tipButton.do {
            $0.setImage(tipImage, for: .normal)
            $0.tintColor = .gray300
        }
        
        labelStack.do {
            $0.axis = .horizontal
            $0.spacing = 10
            $0.alignment = .fill
            $0.distribution = .fill
        }
        
        toolTipView.do {
            $0.superview = tipButton
        }
    }
    
}


// MARK: - Extensions

public extension MemoriesCalendarPageTitleView {
    
    func setTitle(_ title: String) {
        self.titleLabel.text = title
    }
    
    func setMemoryCount(_ count: Int) {
        self.memoryCountLabel.text = "\(count)개의 추억"
    }
    
}
