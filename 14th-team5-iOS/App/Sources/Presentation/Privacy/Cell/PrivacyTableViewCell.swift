//
//  PrivacyTableViewCell.swift
//  App
//
//  Created by Kim dohyun on 12/16/23.
//

import UIKit

import Core
import DesignSystem
import RxSwift
import RxCocoa
import ReactorKit
import SnapKit
import Then

public final class PrivacyTableViewCell: BaseTableViewCell<PrivacyCellReactor> {
    //MARK: Views
    private let descrptionLabel: BBLabel = BBLabel(.head2Regular, textColor: .gray200)
    private let versionLabel: BBLabel = BBLabel(.caption, textColor: .gray200)
    private let arrowAccessView: UIImageView = UIImageView()
    
    
    public override func setupUI() {
        super.setupUI()
        contentView.addSubviews(descrptionLabel, arrowAccessView, versionLabel)
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        
        contentView.do {
            $0.backgroundColor = DesignSystemAsset.black.color
        }
        
        arrowAccessView.do {
            $0.contentMode = .scaleAspectFill
            $0.image = DesignSystemAsset.settingArrow.image
        }
        
        descrptionLabel.do {
            $0.textAlignment = .left
        }
        
        versionLabel.do {
            $0.textAlignment = .justified
            $0.sizeToFit()
        }
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        descrptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(11)
            $0.left.equalToSuperview().offset(16)
            $0.height.equalTo(22)
            $0.centerY.equalToSuperview()
        }
        
    }
    
    public override func bind(reactor: PrivacyCellReactor) {
        reactor.state
            .map { $0.descrption}
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")
            .drive(descrptionLabel.rx.text)
            .disposed(by: disposeBag)
    
        reactor.state
            .map { !$0.descrption.contains("버전") }
            .distinctUntilChanged()
            .bind(to: versionLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isCheck ? "최신 버전입니다" : "최신 버전으로 업데이트해주세요" }
            .distinctUntilChanged()
            .bind(to: versionLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isCheck }
            .distinctUntilChanged()
            .withUnretained(self)
            .bind(onNext: { $0.0.setupVersionLabel(isCheck: $0.1)})
            .disposed(by: disposeBag)
        
            
    }
    
}


extension PrivacyTableViewCell {
    
    private func setupVersionLabel(isCheck: Bool) {
        if isCheck {
            versionLabel.snp.makeConstraints {
                $0.height.equalTo(22)
                $0.right.equalToSuperview().offset(-16)
                $0.centerY.equalTo(descrptionLabel)
            }
            
            arrowAccessView.snp.removeConstraints()
        } else {
            arrowAccessView.snp.makeConstraints {
                $0.right.equalToSuperview().offset(-16)
                $0.width.equalTo(7)
                $0.height.equalTo(12)
                $0.centerY.equalTo(descrptionLabel)
            }
            
            versionLabel.snp.makeConstraints {
                $0.height.equalTo(22)
                $0.right.equalTo(arrowAccessView.snp.left).offset(-12)
                $0.centerY.equalTo(descrptionLabel)
            }
        }
        
    }
    
}
