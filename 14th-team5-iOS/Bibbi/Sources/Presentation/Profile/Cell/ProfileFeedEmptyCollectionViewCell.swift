//
//  ProfileFeedEmptyCollectionViewCell.swift
//  App
//
//  Created by Kim dohyun on 1/1/24.
//

import UIKit

import Core
import DesignSystem
import RxCocoa
import ReactorKit
import SnapKit
import Then

final class ProfileFeedEmptyCollectionViewCell: BaseCollectionViewCell<ProfileFeedEmptyCellReactor> {
    
    
    private let emptyImageView: UIImageView = UIImageView()
    private let emptyDescrptionLabel: BBLabel = BBLabel(.body1Regular, textColor: .gray300)
    
    
    public override func prepareForReuse() {
        emptyImageView.image = nil
        emptyDescrptionLabel.text = ""
    }
    
    override func setupUI() {
        super.setupUI()
        contentView.addSubviews(emptyImageView, emptyDescrptionLabel)
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        emptyImageView.do {
            $0.contentMode = .scaleAspectFill
        }
        
        emptyDescrptionLabel.do {
            $0.numberOfLines = 1
            $0.textAlignment = .center
        }
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        emptyImageView.snp.makeConstraints {
            $0.width.height.equalTo(171)
            $0.top.equalToSuperview().offset(100)
            $0.centerX.equalToSuperview()
        }
        
        emptyDescrptionLabel.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.top.equalTo(emptyImageView.snp.bottom).offset(20)
            $0.centerX.equalTo(emptyImageView)
        }
    }
    
    override func bind(reactor: ProfileFeedEmptyCellReactor) {
        reactor.state
            .map { $0.descrption }
            .asDriver(onErrorJustReturn: "")
            .drive(emptyDescrptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.resource }
            .map { DesignSystemImages.Image(named: $0, in: DesignSystemResources.bundle, with: nil)}
            .asDriver(onErrorJustReturn: .none)
            .drive(emptyImageView.rx.image)
            .disposed(by: disposeBag)
        
    }
    
}



