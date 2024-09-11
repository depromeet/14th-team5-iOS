//
//  FamilyProfileCell.swift
//  App
//
//  Created by 김건우 on 12/12/23.
//

import Core
import DesignSystem
import UIKit

import ReactorKit
import RxSwift
import SnapKit
import Then

final public class FamilyMemberCell: BaseTableViewCell<FamilyMemberCellReactor> {
    
    // MARK: - Views
    
    private let profileBackground: UIView = UIView()
    private let profileImage: UIImageView = UIImageView()
    private let profilePlaceholder: BBLabel = BBLabel(.head2Bold, textAlignment: .center, textColor: .gray200)
    private let birthBadge: UIImageView = UIImageView()
    
    private let labelStack: UIStackView = UIStackView()
    private let nameLabel: BBLabel = BBLabel(.body1Regular, textColor: .gray200)
    private let isMeLabel: BBLabel = BBLabel(.body2Regular, textColor: .gray500)
    
    private let rightArrowSymbol: UIImageView = UIImageView()
    
    
    // MARK: - Properties
    
    static let id: String = "FamilyMemberCell"
    
    private var containerSize: CGFloat {
        guard let reactor else { return 52 }
        
        let size: CGFloat = switch reactor.initialState.kind {
        case .emoji: 44
        case .management: 52
        }
        
        return size
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
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel.text = ""
        isMeLabel.text = ""
        profileImage.image = nil
    }
    
    public override func bind(reactor: FamilyMemberCellReactor) {
        super.bind(reactor: reactor)
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: FamilyMemberCellReactor) {
        Observable<Reactor.Action>.merge([
            Observable.just(.checkIsMe),
            Observable.just(.checkIsMemberBirth)
        ])
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: FamilyMemberCellReactor) {
        let memberName = reactor.state
            .map { $0.member.name }
            .asDriver(onErrorJustReturn: .none)
        
        memberName
            .distinctUntilChanged()
            .drive(nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        memberName
            .distinctUntilChanged()
            .drive(profilePlaceholder.rx.firstLetterText)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isHiddenIsMeMark }
            .distinctUntilChanged()
            .bind(with: self) { $0.isMeLabel.text = $1 ? "" : "Me" }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isHiddenBirthBadge}
            .distinctUntilChanged()
            .bind(to: birthBadge.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.member.profileImageURL }
            .distinctUntilChanged()
            .bind(to: profileImage.rx.kingfisherImage)
            .disposed(by: disposeBag)
        
        let kind = reactor.state
            .map { $0.kind }
            .map { $0 == .emoji }
            .asDriver(onErrorJustReturn: false)
        
        kind
            .distinctUntilChanged()
            .drive(rightArrowSymbol.rx.isHidden)
            .disposed(by: disposeBag)
        
    }
    
    public override func setupUI() {
        super.setupUI()
        profileBackground.addSubviews(profilePlaceholder, profileImage)
        contentView.addSubviews(profileBackground, birthBadge,labelStack, rightArrowSymbol)
        labelStack.addArrangedSubviews(nameLabel, isMeLabel)
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()

        profileBackground.snp.makeConstraints {
             $0.size.equalTo(containerSize)
             $0.leading.equalTo(contentView.snp.leading).offset(20)
             $0.verticalEdges.equalToSuperview().inset(12)
         }
        
        birthBadge.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.top.equalTo(profileBackground.snp.top).offset(-5)
            $0.trailing.equalTo(profileBackground.snp.trailing).offset(5)
        }
        
        profilePlaceholder.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        profileImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        labelStack.snp.makeConstraints {
            $0.leading.equalTo(profileBackground.snp.trailing).offset(16)
            $0.centerY.equalTo(profileBackground.snp.centerY)
        }
        
        rightArrowSymbol.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-20)
        }
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        
        self.selectionStyle = .none
        self.backgroundColor = .clear
        
        profileBackground.do {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = containerSize / 2
            $0.backgroundColor = UIColor.gray800
        }
        
        birthBadge.do {
            $0.image = DesignSystemAsset.birthday.image
            $0.contentMode = .scaleAspectFit
        }
        
        profileImage.do {
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = containerSize / 2
        }
        
        labelStack.do {
            $0.axis = .vertical
            $0.spacing = 3
            $0.alignment = .fill
            $0.distribution = .fillProportionally
        }
        
        rightArrowSymbol.do {
            let arrowRight = DesignSystemAsset.arrowRight.image
            $0.image = arrowRight.withRenderingMode(.alwaysTemplate)
            $0.tintColor = UIColor.gray500
            $0.contentMode = .scaleAspectFill
        }
    }
    
}
