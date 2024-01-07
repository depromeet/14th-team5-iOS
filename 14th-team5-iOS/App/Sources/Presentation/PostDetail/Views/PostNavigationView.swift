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
import Then

final class PostNavigationView: BaseView<PostReactor> {
    typealias Layout = PostAutoLayout.NavigationView
    
    private let backButton: UIButton = UIButton()
    private let profileImageView: UIImageView = UIImageView()
    private let nameLabel: UILabel = BibbiLabel(.body1Regular, textColor: .gray100)
    private let dateLabel: UILabel = BibbiLabel(.caption, textColor: .gray400)
    
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
            .bind(onNext: {
                $0.0.setData(data: $0.1)
            })
            .disposed(by: disposeBag)
    }
    
    override func setupUI() {
        addSubviews(backButton, profileImageView, nameLabel,
                    dateLabel)
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
    }
    
    override func setupAttributes() {
        backButton.do {
            $0.backgroundColor = .clear
            $0.layer.cornerRadius = Layout.BackButton.cornerRadius
            $0.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
            $0.tintColor = .white
        }
        
        profileImageView.do {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = Layout.ProfileImageView.cornerRadius
        }
    }
}

extension PostNavigationView {
    func setData(data: PostListData) {
        guard let author = data.author,
              let url = URL(string: author.profileImageURL ?? "https://search.pstatic.net/sunny/?src=https%3A%2F%2Fi.pinimg.com%2Foriginals%2F37%2F1e%2F6f%2F371e6f8759c86ad13023ac032d612dc2.jpg&type=sc960_832") else {
            return
        }
        profileImageView.kf.setImage(with: url)
        nameLabel.text = author.name
        dateLabel.text = data.time
    }
}
