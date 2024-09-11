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
    private let containerView: UIView = UIView()
    private let firstNameLabel: UILabel = BBLabel(.head2Bold, textAlignment: .center)
    private let profileImageView: UIImageView = UIImageView()
    private let profileButton: UIButton = UIButton()
    
    private let userNameStack: UIStackView = UIStackView()
    private let userNameLabel: BBLabel = BBLabel(.body2Bold, textColor: .gray100)
    private let createdAtLabel: BBLabel = BBLabel(.body2Regular, textColor: .gray500)
    
    private let commentLabel: BBLabel = BBLabel(.body1Regular, textColor: .gray100)
    
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
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
        
        userNameLabel.text = String.none
        createdAtLabel.text = String.none
        profileImageView.image = nil
    }
    
    public override func bind(reactor: CommentCellReactor) {
        super.bind(reactor: reactor)
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: CommentCellReactor) { 
        Observable<Reactor.Action>.merge(
            Observable.just(Reactor.Action.fetchUserName),
            Observable.just(Reactor.Action.fetchProfileImageUrlString)
        )
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        profileButton.rx.tap
            .throttle(RxConst.milliseconds300Interval, scheduler: RxSchedulers.main)
            .map { Reactor.Action.didTapProfileButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: CommentCellReactor) {
        let userName = reactor.state.map({ $0.userName }).asDriver(onErrorJustReturn: .none)
        
        userName
            .distinctUntilChanged()
            .drive(userNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        userName
            .distinctUntilChanged()
            .drive(with: self) { $0.userNameLabel.text = $1[0] }
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
        
        containerView.addSubviews(firstNameLabel, profileImageView, profileButton)
        contentView.addSubviews(containerView, userNameStack, commentLabel)
        userNameStack.addArrangedSubviews(userNameLabel, createdAtLabel)
    }
    
    public override func setupAutoLayout() {
        super.setupUI()
        
        containerView.snp.makeConstraints {
            $0.size.equalTo(44)
            $0.top.equalTo(contentView.snp.top).offset(8)
            $0.leading.equalTo(contentView.snp.leading).offset(20)
        }
        
        profileButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        firstNameLabel.snp.makeConstraints {
            $0.size.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints {
            $0.size.equalToSuperview()
        }
        
        userNameStack.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalTo(containerView.snp.trailing).offset(18)
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
        
        profileButton.do {
            $0.setTitle(.none, for: .normal)
            $0.backgroundColor = UIColor.clear
        }
        
        containerView.do {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 44 / 2
            $0.backgroundColor = UIColor.gray800
        }
        
        profileImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 44 / 2
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
