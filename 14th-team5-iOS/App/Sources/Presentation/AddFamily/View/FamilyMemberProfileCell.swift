//
//  FamilyProfileCell.swift
//  App
//
//  Created by 김건우 on 12/12/23.
//

import UIKit

import Core
import ReactorKit
import RxSwift
import SnapKit
import Then

final class FamiliyMemberProfileCell: BaseTableViewCell<FamilyMemberProfileCellReactor> {
    // MARK: - Views
    private let memberImageView: UIImageView = UIImageView()
    
    private let labelStackView: UIStackView = UIStackView()
    private let memberNameLabel: UILabel = UILabel()
    private let isMeLabel: UILabel = UILabel()
    
    // MARK: - Properties
    static let id: String = "YourFamilyProfileCell"
    
    // MARK: - Intializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    override func setupUI() {
        super.setupUI()
        contentView.addSubviews(
            memberImageView, labelStackView
        )
        
        labelStackView.addArrangedSubviews(
            memberNameLabel, isMeLabel
        )
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        memberImageView.snp.makeConstraints {
            $0.leading.equalTo(contentView.snp.leading).offset(AddFamilyCell.AutoLayout.profileImageLeadingOffsetValue)
            $0.top.equalTo(contentView.snp.top).offset(AddFamilyCell.AutoLayout.profileImageTopOffsetValue)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-AddFamilyCell.AutoLayout.profileImageTopOffsetValue)
            $0.width.height.equalTo(AddFamilyCell.AutoLayout.profileImageWidthValue)
        }
        
        labelStackView.snp.makeConstraints {
            $0.leading.equalTo(memberImageView.snp.trailing).offset(AddFamilyCell.AutoLayout.profileImageLeadingOffsetValue)
            $0.centerY.equalTo(memberImageView.snp.centerY)
        }
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        memberImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = AddFamilyCell.AutoLayout.profileImageWidthValue / 2.0
        }
        
        labelStackView.do {
            $0.axis = .vertical
            $0.spacing = 3.0
            $0.alignment = .fill
            $0.distribution = .fillProportionally
        }
        
        memberNameLabel.do {
            $0.textColor = UIColor.white
            $0.font = UIFont.systemFont(ofSize: AddFamilyCell.Attribute.nameLabelFontSize)
        }
        
        isMeLabel.do {
            $0.textColor = UIColor.white
            $0.font = UIFont.systemFont(ofSize: AddFamilyCell.Attribute.meLabelFontSize)
        }
        
        contentView.backgroundColor = UIColor(red: 0.09, green: 0.09, blue: 0.09, alpha: 1)
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
            .bind(to: memberNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        // TODO: - '나'인지 확인하는 로직 구현하기
        reactor.state.map { $0.memeberId }
            .map { true }
            .bind(to: isMeLabel.rx.isMeText)
            .disposed(by: disposeBag)
        
        // TODO: - '나'인지 확인하는 로직 구현하기
        reactor.state.map { $0.memeberId }
            .map { true }
            .bind(to: labelStackView.rx.isMeSpacing)
            .disposed(by: disposeBag)
    }
}
