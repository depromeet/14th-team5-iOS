//
//  ProfileView.swift
//  App
//
//  Created by 마경미 on 05.12.23.
//

import UIKit
import Core
import Domain

import Kingfisher
import RxSwift

final class ProfileView: UIView {
    typealias Layout = HomeAutoLayout.ProfileView
    
    private let defaultNameLabel = BibbiLabel(.head1, alignment: .center, textColor: .gray200)
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    
    let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
        setupAutoLayout()
        setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        addSubviews(imageView, nameLabel, defaultNameLabel)
    }
    
    private func setupAutoLayout() {
        imageView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.width.height.equalTo(64)
            $0.top.leading.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(Layout.NameLabel.topOffset)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        defaultNameLabel.snp.makeConstraints {
            $0.center.equalTo(imageView)
        }
    }
    
    private func setupAttributes() {
        nameLabel.do {
            $0.font = UIFont.pretendard(.caption)
            $0.textAlignment = .center
            $0.textColor = .gray300
            
            $0.numberOfLines = 1
            $0.lineBreakMode = .byTruncatingTail
        }
        
        imageView.do {
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 64 / 2
        }
    }
}

extension ProfileView {
    func setProfile(profile: ProfileData) {
        if let profileImageURL = profile.profileImageURL,
           let url = URL(string: profileImageURL), !profileImageURL.isEmpty {
            imageView.kf.setImage(with: url)
            defaultNameLabel.isHidden = true
        } else {
            guard let name = profile.name.first else {
                return
            }
            imageView.backgroundColor = .gray800
            defaultNameLabel.text = "\(name)"
        }
        nameLabel.text = profile.name
    }
}
