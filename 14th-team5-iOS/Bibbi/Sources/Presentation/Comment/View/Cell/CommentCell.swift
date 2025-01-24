//
//  CommentCell.swift
//  App
//
//  Created by 김건우 on 1/18/24.
//

import Core
import DesignSystem
import UIKit

import ReactorKit
import RxSwift
import SnapKit
import Then

final public class CommentCell: BaseTableViewCell<CommentCellReactor> {
    
    // MARK: - Views
    
    private let profileBackground: UIView = UIView()
    private let profilePlaceholder: UILabel = BBLabel(.head2Bold, textAlignment: .center)
    private let profileImage: UIImageView = UIImageView()
    private let profileButton: UIButton = UIButton()
    
    private let labelStack: UIStackView = UIStackView()
    private let nameLabel: BBLabel = BBLabel(.body2Bold, textColor: .gray100)
    private let createdAtLabel: BBLabel = BBLabel(.body2Regular, textColor: .gray500)
    
    private let commentLabel: BBLabel = BBLabel(.body1Regular, textColor: .gray100)
    
    
    // MARK: - Properties
    
    static var id: String = "CommentCell"
    
    
    // MARK: - Helpers
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel.text = ""
        createdAtLabel.text = ""
        profileImage.image = nil
        
        disposeBag = DisposeBag() // TODO: - 코드 삭제 테스트하기
    }
    
    public override func bind(reactor: CommentCellReactor) {
        super.bind(reactor: reactor)
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: CommentCellReactor) { 
        Observable<Reactor.Action>.merge(
            Observable.just(Reactor.Action.fetchUserName),
            Observable.just(Reactor.Action.fetchProfileImage)
        )
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        profileButton.rx.tap
            .throttle(RxInterval._300milliseconds, scheduler: RxScheduler.main)
            .map { Reactor.Action.didTapProfileButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: CommentCellReactor) {
        let mamberName = reactor.state
            .compactMap { $0.memberName }
            .asDriver(onErrorJustReturn: "")
        
        mamberName
            .distinctUntilChanged()
            .drive(nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        mamberName
            .distinctUntilChanged()
            .drive(profilePlaceholder.rx.firstLetterText)
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.profileImageUrl }
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind(to: profileImage.rx.kfImage)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.comment.createdAt }
            .distinctUntilChanged()
            .map { $0.relativeFormatter() } // Reactor 안으로 집어넣기
            .bind(to: createdAtLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.comment.comment }
            .distinctUntilChanged()
            .bind(to: commentLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    public override func setupUI() {
        super.setupUI()
        
        profileBackground.addSubviews(profilePlaceholder, profileImage, profileButton)
        contentView.addSubviews(profileBackground, labelStack, commentLabel)
        labelStack.addArrangedSubviews(nameLabel, createdAtLabel)
    }
    
    public override func setupAutoLayout() {
        super.setupUI()
        
        profileBackground.snp.makeConstraints {
            $0.size.equalTo(44)
            $0.top.equalTo(contentView.snp.top).offset(8)
            $0.leading.equalTo(contentView.snp.leading).offset(20)
        }
        
        profileButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        profilePlaceholder.snp.makeConstraints {
            $0.size.equalToSuperview()
        }
        
        profileImage.snp.makeConstraints {
            $0.size.equalToSuperview()
        }
        
        labelStack.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalTo(profileBackground.snp.trailing).offset(18)
        }
        
        commentLabel.snp.makeConstraints {
            $0.top.equalTo(labelStack.snp.bottom).offset(8)
            $0.leading.equalTo(labelStack.snp.leading)
            $0.trailing.equalToSuperview().offset(-8)
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        
        contentView.do {
            $0.backgroundColor = UIColor.bibbiBlack
        }
        
        profileButton.do {
            $0.setTitle("", for: .normal)
            $0.backgroundColor = UIColor.clear
        }
        
        profileBackground.do {
            $0.layer.cornerRadius = 44 / 2
            $0.backgroundColor = UIColor.gray800
        }
        
        profileImage.do {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 44 / 2
            $0.contentMode = .scaleAspectFill
        }
        
        labelStack.do {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.alignment = .fill
        }
        
        commentLabel.do {
            $0.numberOfLines = 0
        }
    }
}
