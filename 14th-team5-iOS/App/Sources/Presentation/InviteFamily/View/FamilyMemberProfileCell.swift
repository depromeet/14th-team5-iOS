//
//  FamilyProfileCell.swift
//  App
//
//  Created by 김건우 on 12/12/23.
//

import UIKit

import Core
import DesignSystem
import ReactorKit
import RxSwift
import SnapKit
import Then

final class FamiliyMemberProfileCell: BaseTableViewCell<FamilyMemberProfileCellReactor> {
    // MARK: - Views
    private let memberImageBackgroundView: UIView = UIView()
    private let firstNameLabel: TypeSystemLabel = TypeSystemLabel(.head2Bold)
    private let memberImageView: UIImageView = UIImageView()
    
    private let namelabelStackView: UIStackView = UIStackView()
    private let nameLabel: TypeSystemLabel = TypeSystemLabel(.body1Regular)
    private let isMeLabel: TypeSystemLabel = TypeSystemLabel(.body2Regular)
    
    // MARK: - Properties
    static let id: String = "FamilyProfileCell"
    
    // MARK: - Intializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        memberImageView.image = nil
    }
    
    // MARK: - Helpers
    override func setupUI() {
        super.setupUI()
        memberImageBackgroundView.addSubviews(
            firstNameLabel, memberImageView
        )
        contentView.addSubviews(
            memberImageBackgroundView, namelabelStackView
        )
        
        namelabelStackView.addArrangedSubviews(
            nameLabel, isMeLabel
        )
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        memberImageBackgroundView.snp.makeConstraints {
            $0.leading.equalTo(contentView.snp.leading).offset(AddFamilyCell.AutoLayout.profileImageLeadingOffsetValue)
            $0.top.equalTo(contentView.snp.top).offset(AddFamilyCell.AutoLayout.profileImageTopOffsetValue)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-AddFamilyCell.AutoLayout.profileImageTopOffsetValue)
            $0.width.height.equalTo(AddFamilyCell.AutoLayout.profileImageWidthValue)
        }
        
        firstNameLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        memberImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        namelabelStackView.snp.makeConstraints {
            $0.leading.equalTo(memberImageView.snp.trailing).offset(AddFamilyCell.AutoLayout.profileImageLeadingOffsetValue)
            $0.centerY.equalTo(memberImageView.snp.centerY)
        }
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        memberImageBackgroundView.do {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = AddFamilyCell.AutoLayout.profileImageWidthValue / 2.0
            $0.backgroundColor = UIColor.darkGray
        }
        
        firstNameLabel.do {
            $0.textAlignment = .center
        }
        
        memberImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = AddFamilyCell.AutoLayout.profileImageWidthValue / 2.0
        }
        
        namelabelStackView.do {
            $0.axis = .vertical
            $0.spacing = 3.0
            $0.alignment = .fill
            $0.distribution = .fillProportionally
        }
        
        isMeLabel.do {
            $0.textTypeSystemColor = .gray500
        }
        
        contentView.backgroundColor = DesignSystemAsset.black.color
    }
    
    override func bind(reactor: FamilyMemberProfileCellReactor) {
        super.bind(reactor: reactor)
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: FamilyMemberProfileCellReactor) { }
    
    private func bindOutput(reactor: FamilyMemberProfileCellReactor) {
        reactor.state.map { $0.imageUrl }
            .compactMap { $0 }
            .withUnretained(self)
            .subscribe {
                $0.0.memberImageView.kf.setImage(
                    with: URL(string: $0.1),
                    options: [
                        .transition(.fade(0.25))
                    ]
                )
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.name }
            .bind(to: nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.name }
            .distinctUntilChanged()
            .map { String($0[0])  }
            .bind(to: firstNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        // TODO: - '나'인지 확인하는 로직 구현하기
        reactor.state.map { $0.memeberId }
            .map { true }
            .bind(to: isMeLabel.rx.isMeText)
            .disposed(by: disposeBag)
        
        // TODO: - '나'인지 확인하는 로직 구현하기
        reactor.state.map { $0.memeberId }
            .map { true }
            .bind(to: namelabelStackView.rx.isMeSpacing)
            .disposed(by: disposeBag)
    }
}
