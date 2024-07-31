//
//  ProfileDetailViewController.swift
//  App
//
//  Created by Kim dohyun on 2/10/24.
//

import UIKit

import Core
import DesignSystem
import Kingfisher
import ReactorKit
import SnapKit
import Then

final class ProfileDetailViewController: BaseViewController<ProfileDetailViewReactor> {
    private let profileImageView: UIImageView = UIImageView()
    private let nickNameLabel: BBLabel = BBLabel(.head1, textAlignment: .center, textColor: .gray200)
    private let blurView: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterialDark))
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        view.addSubviews(blurView, profileImageView, nickNameLabel, navigationBarView)
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        
        blurView.do {
            $0.layer.zPosition = -100
            $0.backgroundColor = DesignSystemAsset.black.color.withAlphaComponent(0.9)
            $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
        
        profileImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 40
            $0.clipsToBounds = true
        }
        
        navigationBarView.do {
            $0.layer.zPosition = 100
            $0.setNavigationView(leftItem: .arrowLeft, centerItem: .label(nil), rightItem: .empty)
        }
    
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        
        blurView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(375)
            $0.center.equalToSuperview()
        }
        
        nickNameLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    override func bind(reactor: ProfileDetailViewReactor) {
        super.bind(reactor: reactor)
        
        reactor.pulse(\.$profileURL)
            .filter { $0.isFileURL }
            .withUnretained(self)
            .bind { owner, _ in
                owner.profileImageView.image = nil
                owner.nickNameLabel.isHidden = false
            }.disposed(by: disposeBag)
        
        reactor.pulse(\.$profileURL)
            .filter { $0.isFileURL == false }
            .withUnretained(self)
            .bind {
                $0.0.profileImageView.kf.indicatorType = .activity
                $0.0.profileImageView.kf.setImage(with: $0.1, options: [.transition(.fade(0.5))])
                $0.0.nickNameLabel.isHidden = true
            }.disposed(by: disposeBag)
        
        reactor.pulse(\.$userNickname)
            .compactMap { $0.first }
            .map { "\($0)" }
            .bind(to: nickNameLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
