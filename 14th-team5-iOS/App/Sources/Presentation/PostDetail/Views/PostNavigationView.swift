//
//  PostHeaderView.swift
//  App
//
//  Created by 마경미 on 20.12.23.
//

import UIKit
import Core
import Domain

import SnapKit
import RxSwift
import RxCocoa
import Then

final class PostNavigationView: BaseView<PostReactor> {
    typealias Layout = PostAutoLayout.NavigationView
    
    private let defaultNameLabel: UILabel = BBLabel(.head1, textColor: .gray200)
    private let backButton: UIButton = UIButton()
    private let profileImageView: UIImageView = UIImageView()
    private let nameLabel: UILabel = BBLabel(.body1Regular, textColor: .gray100)
    private let dateLabel: UILabel = BBLabel(.caption, textColor: .gray400)
    
    convenience init(reactor: Reactor? = nil) {
        self.init(frame: .zero)
        self.reactor = reactor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func bind(reactor: PostReactor) {
        backButton.rx.tap
            .map { Reactor.Action.tapBackButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.selectedPost }
            .asObservable()
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind(onNext: { $0.0.setData(data: $0.1) })
            .disposed(by: disposeBag)
    }
    
    override func setupUI() {
        addSubviews(backButton, profileImageView, nameLabel,
                    dateLabel, defaultNameLabel)
    }
    
    override func setupAutoLayout() {
        backButton.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
            $0.size.equalTo(Layout.BackButton.size)
        }
        
        profileImageView.snp.makeConstraints {
            $0.size.equalTo(Layout.ProfileImageView.size)
            $0.leading.equalTo(backButton.snp.trailing)
            $0.centerY.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(Layout.NameLabel.leading)
            $0.top.equalTo(profileImageView)
            $0.height.equalTo(Layout.NameLabel.height)
        }
        
        dateLabel.snp.makeConstraints {
            $0.leading.equalTo(nameLabel)
            $0.bottom.equalTo(profileImageView)
            $0.height.equalTo(Layout.DateLabel.height)
        }
        
        defaultNameLabel.snp.makeConstraints {
            $0.center.equalTo(profileImageView)
        }
    }
    
    override func setupAttributes() {
        backButton.do {
            $0.backgroundColor = .clear
            $0.layer.cornerRadius = Layout.BackButton.cornerRadius
            $0.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
            $0.tintColor = .white
        }
        
        profileImageView.do {
            $0.isHidden = true
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = Layout.ProfileImageView.cornerRadius
        }
    }
}

extension PostNavigationView {
    private func setData(data: PostEntity) {
        if let profileImageURL =  data.author.profileImageURL,
           let url = URL(string: profileImageURL),
            !profileImageURL.isEmpty {
                profileImageView.kf.setImage(with: url)
                defaultNameLabel.isHidden = true
            } else {
                defaultNameLabel.text = "\(data.author.name.first ?? "알")"
                profileImageView.kf.base.image = nil
                defaultNameLabel.isHidden = false
                profileImageView.backgroundColor = .gray800
            }
        
        nameLabel.text = data.author.name
        dateLabel.text = data.time.toDate(with: "yyyy-MM-dd'T'HH:mm:ssZ").relativeFormatter()
        
        profileImageView.isHidden = false
    }
}
