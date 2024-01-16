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

final class FamilyMemberProfileCell: BaseTableViewCell<FamilyMemberProfileCellReactor> {
    // MARK: - Views
    private let containerView: UIView = UIView()
    private let firstNameLabel: BibbiLabel = BibbiLabel(.head2Bold, alignment: .center, textColor: .gray200)
    private let profileImageView: UIImageView = UIImageView()
    
    private let labelStack: UIStackView = UIStackView()
    private let nameLabel: BibbiLabel = BibbiLabel(.body1Regular, textColor: .gray200)
    private let isMeLabel: BibbiLabel = BibbiLabel(.body2Regular, textColor: .gray500)
    
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
        profileImageView.image = nil
    }
    
    // MARK: - Helpers
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
                $0.0.profileImageView.kf.setImage(
                    with: URL(string: $0.1),
                    options: [
                        .transition(.fade(0.15))
                    ]
                )
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.name }
            .bind(to: nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.name[0] }
            .distinctUntilChanged()
            .bind(to: firstNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isMe }
            .distinctUntilChanged()
            .bind(to: isMeLabel.rx.isMeText)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isMe }
            .distinctUntilChanged()
            .bind(to: labelStack.rx.isMeSpacing)
            .disposed(by: disposeBag)
    }
    
    override func setupUI() {
        super.setupUI()
        containerView.addSubviews(
            firstNameLabel, profileImageView
        )
        contentView.addSubviews(
            containerView, labelStack
        )
        
        labelStack.addArrangedSubviews(
            nameLabel, isMeLabel
        )
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        containerView.snp.makeConstraints {
            $0.size.equalTo(52)
            $0.leading.equalTo(contentView.snp.leading).offset(20)
            $0.verticalEdges.equalToSuperview().inset(12)
        }
        
        firstNameLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        labelStack.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(16)
            $0.centerY.equalTo(profileImageView.snp.centerY)
        }
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        containerView.do {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 52 / 2
            $0.backgroundColor = .gray800
        }
        
        profileImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 52 / 2
        }
        
        labelStack.do {
            $0.axis = .vertical
            $0.spacing = 3
            $0.alignment = .fill
            $0.distribution = .fillProportionally
        }
        
        contentView.backgroundColor = .bibbiBlack
    }
}
