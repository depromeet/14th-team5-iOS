//
//  FamilyCollectionViewCell.swift
//  App
//
//  Created by 마경미 on 05.12.23.
//

import UIKit
import Core
import Domain

final class FamilyCollectionViewCell: BaseCollectionViewCell<HomeViewReactor> {
    typealias Layout = HomeAutoLayout.ProfileView
    static let id: String = "familyCollectionViewCell"

    private let defaultNameLabel = BibbiLabel(.head1, alignment: .center, textColor: .gray200)
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func bind(reactor: HomeViewReactor) { }
    
    override func setupUI() {
        addSubviews(imageView, nameLabel, defaultNameLabel)
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
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
}

extension FamilyCollectionViewCell {
    func setCell(data: ProfileData) {
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
        nameLabel.text = data.name
    }
}
