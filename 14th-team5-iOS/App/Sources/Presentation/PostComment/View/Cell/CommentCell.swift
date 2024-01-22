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
    private let profileImageView: UIImageView = UIImageView()
    
    private let userNameStack: UIStackView = UIStackView()
    private let userNameLabel: BibbiLabel = BibbiLabel(.body2Bold, textColor: .gray100)
    private let createdAtLabel: BibbiLabel = BibbiLabel(.body2Regular, textColor: .gray500)
    
    private let commentLabel: BibbiLabel = BibbiLabel(.body1Regular, textColor: .gray100)
    
    // MARK: - Properties
    static var id: String = "CommentCell"
    
    // MARK: - Intialzier
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helerps
    public override func bind(reactor: CommentCellReactor) {
        super.bind(reactor: reactor)
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: CommentCellReactor) { 
        Observable<Void>.just(())
            .map { Reactor.Action.fetchUserName }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        Observable<Void>.just(())
            .map { Reactor.Action.fetchProfileImageUrlString }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: CommentCellReactor) {
        reactor.state.map { $0.userName }
            .distinctUntilChanged()
            .bind(to: userNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.profileImageUrlString }
            .distinctUntilChanged()
            .bind(to: profileImageView.rx.kingfisherImage)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.createdAt }
            .distinctUntilChanged()
            .map { $0.relativeFormatter() }
            .bind(to: createdAtLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.comment }
            .distinctUntilChanged()
            .bind(to: commentLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    public override func setupUI() {
        super.setupUI()
        
        contentView.addSubviews(profileImageView, userNameStack, commentLabel)
        userNameStack.addArrangedSubviews(userNameLabel, createdAtLabel)
    }
    
    public override func setupAutoLayout() {
        super.setupUI()
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(8)
            $0.leading.equalTo(contentView.snp.leading).offset(20)
            $0.size.equalTo(44)
        }
        
        userNameStack.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(18)
        }
        
        commentLabel.snp.makeConstraints {
            $0.top.equalTo(userNameStack.snp.bottom).offset(8)
            $0.leading.equalTo(userNameStack.snp.leading)
            $0.trailing.equalToSuperview().offset(-8)
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        
        contentView.do {
            $0.backgroundColor = UIColor.bibbiBlack
        }
        
        profileImageView.do {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 44 / 2
            $0.contentMode = .scaleAspectFill
            
            $0.backgroundColor = UIColor.gray100
            $0.image = DesignSystemAsset.emoji1.image
        }
        
        userNameStack.do {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.alignment = .fill
        }
        
        commentLabel.do {
            $0.numberOfLines = 0
        }
    }
}
