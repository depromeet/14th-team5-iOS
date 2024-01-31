//
//  FamilyCollectionViewCell.swift
//  App
//
//  Created by 마경미 on 05.12.23.
//

import UIKit

import Core
import Domain
import DesignSystem

final class FamilyCollectionViewCell: BaseCollectionViewCell<HomeViewReactor> {
    typealias Layout = HomeAutoLayout.ProfileView
    static let id: String = "familyCollectionViewCell"
    
    private let defaultNameLabel = BibbiLabel(.head1, alignment: .center, textColor: .gray200)
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let rankBadge = UIImageView()
    private let birthdayBadge = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func bind(reactor: HomeViewReactor) { }
    
    override func setupUI() {
        addSubviews(imageView, nameLabel, defaultNameLabel,
                    birthdayBadge, rankBadge)
    }
    
    override func prepareForReuse() {
        imageView.image = nil
        rankBadge.image = nil
        birthdayBadge.image = nil
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = nil
    }

    override func setupAutoLayout() {
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
        
        birthdayBadge.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.top.trailing.equalToSuperview()
        }
        
        rankBadge.snp.makeConstraints {
            $0.width.equalTo(20)
            $0.height.equalTo(24)
            $0.leading.bottom.equalTo(imageView)
        }
    }
    
    override func setupAttributes() {
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
        
        birthdayBadge.do {
            $0.image = DesignSystemAsset.dayOfBirth.image
            $0.isHidden = true
        }
        
        rankBadge.do {
            $0.isHidden = true
        }
    }
}

extension FamilyCollectionViewCell {
    func setCell(data: ProfileData) {
        setupImageView(with: data)
        nameLabel.text = data.name
        setRankBadge(for: data)
        setBirthdayBadge(for: data)
    }
    
    private func setupImageView(with data: ProfileData) {
        if let profileImageURL = data.profileImageURL,
           let url = URL(string: profileImageURL), !profileImageURL.isEmpty {
            imageView.kf.setImage(with: url)
            defaultNameLabel.isHidden = true
        } else {
            guard let name = data.name.first else {
                return
            }
            defaultNameLabel.isHidden = false
            imageView.backgroundColor = .gray800
            defaultNameLabel.text = "\(name)"
        }
    }
    
    private func setRankBadge(for data: ProfileData) {
        guard let rank = data.postRank else {
            imageView.alpha = 0.5
            defaultNameLabel.alpha = 0.5
            imageView.layer.borderWidth = 0
            return
        }
        
        imageView.alpha = 1
        defaultNameLabel.alpha = 1
        imageView.layer.borderWidth = 1
        rankBadge.isHidden = false
        
        switch RankBadge(rawValue: rank) {
        case .one:
            imageView.layer.borderColor = UIColor.mainYellow.cgColor
            rankBadge.image = DesignSystemAsset.rank1.image
        case .two:
            imageView.layer.borderColor = UIColor.graphicGreen.cgColor
            rankBadge.image = DesignSystemAsset.rank2.image
        case .three:
            imageView.layer.borderColor = UIColor.graphicOrange.cgColor
            rankBadge.image = DesignSystemAsset.rank3.image
        case .none:
            rankBadge.isHidden = true
        }
    }
    
    private func setBirthdayBadge(for data: ProfileData) {
        birthdayBadge.isHidden = (data.dayOfBirth.month, data.dayOfBirth.day) != (Date().month, Date().day)
    }
}

enum RankBadge: Int {
    case one = 1
    case two
    case three
}
