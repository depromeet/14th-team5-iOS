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
    private let navigationBar: BibbiNavigationBarView = BibbiNavigationBarView()
    private let profileImageView: UIImageView = UIImageView()
    private let blurView: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterialDark))
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func setupUI() {
        super.setupUI()
        view.addSubviews(blurView, profileImageView, navigationBar)
    }
    
    override func setupAttributes() {

        blurView.do {
            $0.frame = view.bounds
            $0.backgroundColor = DesignSystemAsset.black.color.withAlphaComponent(0.9)
            $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
        
        profileImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 40
            $0.clipsToBounds = true
        }
        
        navigationBar.do {
            $0.leftBarButtonItem = .arrowLeft
            $0.leftBarButtonItemTintColor = .gray300
        }
    
    }
    
    override func setupAutoLayout() {

        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(42)
        }
        
        profileImageView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(375)
            $0.center.equalToSuperview()
        }
    }
    
    override func bind(reactor: ProfileDetailViewReactor) {
        reactor.pulse(\.$profileURL)
            .withUnretained(self)
            .bind {
                $0.0.profileImageView.kf.indicatorType = .activity
                $0.0.profileImageView.kf.setImage(with: $0.1, options: [.transition(.fade(0.5))])
            }.disposed(by: disposeBag)
        
        navigationBar
            .rx.didTapLeftBarButton
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }.disposed(by: disposeBag)
    }
}
