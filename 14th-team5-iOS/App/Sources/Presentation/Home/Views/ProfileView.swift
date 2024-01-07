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
    
    private let imageView = UIImageView()
    private let nameLabel = BibbiLabel(.caption, alignment: .center, textColor: .gray300)
    
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
        guard let imageURL: URL = URL(string: profile.profileImageURL ?? "https://search.pstatic.net/sunny/?src=https%3A%2F%2Fi.pinimg.com%2Foriginals%2F37%2F1e%2F6f%2F371e6f8759c86ad13023ac032d612dc2.jpg&type=sc960_832") else {
            return
        }
        imageView.kf.setImage(with: imageURL)
        nameLabel.text = profile.name
    }
}
