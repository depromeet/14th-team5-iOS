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

final public class FamilyMemberCell: BaseTableViewCell<FamilyMemberCellReactor> {
    
    // MARK: - Views
    
    private let containerView: UIView = UIView()
    private let firstNameLabel: BBLabel = BBLabel(.head2Bold, textAlignment: .center, textColor: .gray200)
    private let profileImageView: UIImageView = UIImageView()
    private let dayOfBirthBadgeView: UIImageView = UIImageView()
    
    private let labelStack: UIStackView = UIStackView()
    private let nameLabel: BBLabel = BBLabel(.body1Regular, textColor: .gray200)
    private let isMeLabel: BBLabel = BBLabel(.body2Regular, textColor: .gray500)
    private let rightArrowImageView: UIImageView = UIImageView()
    
    
    // MARK: - Properties
    
    static let id: String = "FamilyProfileCell"
    
    // 요거 깔끔하게 코드 수정
    private var containerSize: CGFloat {
        guard let reactor = reactor else { return 52 }
        return reactor.currentState.cellType == .management ? 52 : 44
    }
    
    // MARK: - Intializer

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helpers
    
    public override func bind(reactor: FamilyMemberCellReactor) {
        super.bind(reactor: reactor)
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: FamilyMemberCellReactor) { }
    
    private func bindOutput(reactor: FamilyMemberCellReactor) {
        reactor.state.compactMap { $0.imageUrl }
            .distinctUntilChanged()
            .bind(to: profileImageView.rx.kingfisherImage)
            .disposed(by: disposeBag)
        
        let name = reactor.state.map({ $0.name }).asDriver(onErrorJustReturn: .none)
        
        name
            .distinctUntilChanged()
            .drive(nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        name
            .distinctUntilChanged()
            .drive(firstNameLabel.rx.firtNameText)
            .disposed(by: disposeBag)
        
        let isMe = reactor.state.map({ $0.isMe }).asDriver(onErrorJustReturn: false)
        
        isMe
            .distinctUntilChanged()
            .drive(isMeLabel.rx.isMeText)
            .disposed(by: disposeBag)
        
        isMe
            .distinctUntilChanged()
            .drive(labelStack.rx.isMeSpacing)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.dayOfBirth }
            .distinctUntilChanged()
            .map { !$0.isEqual([.month, .day], with: .now) }
            .bind(to: dayOfBirthBadgeView.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.cellType }
            .map { $0 != .management }
            .distinctUntilChanged()
            .bind(to: rightArrowImageView.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    public override func setupUI() {
        super.setupUI()
        containerView.addSubviews(
            firstNameLabel, profileImageView
        )
        contentView.addSubviews(
            containerView, dayOfBirthBadgeView,
            labelStack, rightArrowImageView
        )
        labelStack.addArrangedSubviews(
            nameLabel, isMeLabel
        )
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()

        containerView.snp.makeConstraints {
             $0.size.equalTo(containerSize)
             $0.leading.equalTo(contentView.snp.leading).offset(20)
             $0.verticalEdges.equalToSuperview().inset(12)
         }
        
        dayOfBirthBadgeView.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.top.equalTo(containerView.snp.top).offset(-5)
            $0.trailing.equalTo(containerView.snp.trailing).offset(5)
        }
        
        firstNameLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        labelStack.snp.makeConstraints {
            $0.leading.equalTo(containerView.snp.trailing).offset(16)
            $0.centerY.equalTo(containerView.snp.centerY)
        }
        
        rightArrowImageView.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-20)
        }
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        
        self.selectionStyle = .none
        self.backgroundColor = .clear
        
        containerView.do {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = containerSize / 2
            $0.backgroundColor = UIColor.gray800
        }
        
        dayOfBirthBadgeView.do {
            $0.image = DesignSystemAsset.birthday.image
            $0.contentMode = .scaleAspectFit
        }
        
        profileImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = containerSize / 2
        }
        
        labelStack.do {
            $0.axis = .vertical
            $0.spacing = 3
            $0.alignment = .fill
            $0.distribution = .fillProportionally
        }
        
        rightArrowImageView.do {
            let arrowRight = DesignSystemAsset.arrowRight.image
            $0.image = arrowRight.withRenderingMode(.alwaysTemplate)
            $0.tintColor = UIColor.gray500
            $0.contentMode = .scaleAspectFill
        }
    }
    
    public override func prepareForReuse() {
        nameLabel.text = String.none
        isMeLabel.text = String.none
        profileImageView.image = nil
    }
    
}
