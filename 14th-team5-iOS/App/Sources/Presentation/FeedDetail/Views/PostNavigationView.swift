//
//  PostHeaderView.swift
//  App
//
//  Created by 마경미 on 20.12.23.
//

import UIKit

import SnapKit
import Then

final class PostNavigationView: UIView {
    private let backButton: UIButton = UIButton()
    private let profileImageView: UIImageView = UIImageView()
    private let nameLabel: UILabel = UILabel()
    private let dateLabel: UILabel = UILabel()

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
            $0.size.equalTo(52)
        }
        
        profileImageView.snp.makeConstraints {
            $0.size.equalTo(44)
            $0.leading.equalTo(backButton.snp.trailing)
            $0.centerY.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(12)
            $0.top.equalTo(profileImageView)
            $0.height.equalTo(24)
        }
        
        dateLabel.snp.makeConstraints {
            $0.leading.equalTo(nameLabel)
            $0.bottom.equalTo(profileImageView)
            $0.height.equalTo(17)
        }
    }
    
    func setupAttributes() {
        backButton.do {
            $0.backgroundColor = UIColor(red: 0.184, green: 0.184, blue: 0.196, alpha: 1)
            $0.layer.cornerRadius = 10
            $0.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
            $0.tintColor = .white
        }
        
        profileImageView.do {
            $0.layer.cornerRadius = 22
            $0.kf.setImage(with: URL(string: "https://cdn.pixabay.com/photo/2020/05/17/20/21/cat-5183427_1280.jpg"))
        }
        
        nameLabel.do {
            $0.text = "하나밖에없는혈육"
        }
        
        dateLabel.do {
            $0.text = "12월 16일"
        }
    }
}
