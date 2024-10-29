//
//  MemoriesCalendarPostHeaderView.swift
//  App
//
//  Created by 김건우 on 10/17/24.
//

import Core
import UIKit

import Then
import SnapKit
import Kingfisher

final class MemoriesCalendarPostHeaderView: BaseView<MemoriesCalendarPostHeaderReactor> {
    
    // MARK: - Views
    
    private let profileStack: UIStackView = UIStackView()
    private let profileBackgroundView: UIView = UIView()
    private let profileImageButton: UIButton = UIButton(type: .custom)
    private let firstNameLetter: BBLabel = BBLabel(.caption, textColor: .bibbiWhite)
    private let memberNameLabel: BBLabel = BBLabel(.caption, textColor: .gray200)
    
    // MARK: - Properteis
    
    weak var delegate: (any MemoriesCalendarPostHeaderDelegate)?
    
    
    // MARK: - Helpers
    
    public override func bind(reactor: Reactor) {
        super.bind(reactor: reactor)
    }
    
    public override func setupUI() {
        super.setupUI()
        
        addSubview(profileStack)
        profileBackgroundView.addSubviews(firstNameLetter, profileImageButton)
        profileStack.addArrangedSubviews(profileBackgroundView, memberNameLabel)
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        
        profileStack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        profileBackgroundView.snp.makeConstraints {
            $0.size.equalTo(34)
        }
        
        profileImageButton.snp.makeConstraints {
            $0.size.equalTo(34)
        }

        firstNameLetter.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        
        profileStack.do {
            $0.spacing = 12
            $0.axis = .horizontal
        }
        
        profileBackgroundView.do {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 34 / 2
            $0.backgroundColor = UIColor.gray800
            $0.isUserInteractionEnabled = true
        }
        
        profileImageButton.do {
            $0.contentMode = .scaleAspectFill
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 34 / 2
            $0.adjustsImageWhenHighlighted = false
            $0.addTarget(self, action: #selector(didTapProfileImageButton(_:event:)), for: .touchUpInside)
        }
        
        memberNameLabel.do {
            $0.text = "알 수 없음"
        }
        
        firstNameLetter.do {
            $0.text = "알"
        }
    }
    
}


// MARK: - Extensions

extension MemoriesCalendarPostHeaderView {
    
    @objc func didTapProfileImageButton(_ button: UIButton, event: UIControl.Event) {
        delegate?.didTapProfileImageButton?(button, event: event)
    }
    
}

extension MemoriesCalendarPostHeaderView {
    
    func prepareForReuse() {
        profileImageButton.setImage(nil, for: .normal)
        firstNameLetter.text = "알"
        memberNameLabel.text = "알 수 없음"
    }
    
    func setMemberName(text: String?) {
        memberNameLabel.text = text
        firstNameLetter.text = text?[0]
    }
    
    func setProfileImage(imageUrl url: URL) {
        KingfisherManager.shared.retrieveImage(with: url) { result in
            if case let .success(imageResult) = result {
                self.profileImageButton.setBackgroundImage(imageResult.image, for: .normal) // extension으로 빼기
            }
        }
    }
    
}

