//
//  ProfileView.swift
//  App
//
//  Created by 마경미 on 05.12.23.
//

import UIKit
import Domain

import Kingfisher
import RxSwift

final class ProfileView: UIView {
    typealias Layout = HomeAutoLayout.ProfileView
    
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
        addSubviews(imageView, nameLabel)
    }
    
    private func setupAutoLayout() {
        imageView.snp.makeConstraints {
            $0.size.equalTo(Layout.ImageView.size)
            $0.top.leading.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(Layout.NameLabel.topOffset)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func setupAttributes() {
        imageView.do {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = Layout.ImageView.cornerRadius
        }
        
        nameLabel.do {
            $0.textAlignment = .center
        }
    }
}

extension ProfileView {
    func setProfile(profile: ProfileData) {
        guard let imageURL: URL = URL(string: profile.profileImageURL) else {
            return
        }
        imageView.kf.setImage(with: imageURL)
        nameLabel.text = profile.name
    }
}
