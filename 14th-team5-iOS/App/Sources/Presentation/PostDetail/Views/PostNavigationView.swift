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

final class PostNavigationView: UIView {
    typealias Layout = PostAutoLayout.NavigationView
    
    private let backButton: UIButton = UIButton()
    private let profileImageView: UIImageView = UIImageView()
    private let nameLabel: UILabel = BibbiLabel(.body1Regular, textColor: .gray100)
    private let dateLabel: UILabel = BibbiLabel(.caption, textColor: .gray400)

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupAutoLayout()
        setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubviews(backButton, profileImageView, nameLabel,
                    dateLabel)
    }
    
    private func setupAutoLayout() {
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
    
    func setupAttributes() {
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
              let url = URL(string: author.profileImageURL) else {
            return
        }
        profileImageView.kf.setImage(with: url)
        nameLabel.text = author.name
        dateLabel.text = data.time
    }
}
