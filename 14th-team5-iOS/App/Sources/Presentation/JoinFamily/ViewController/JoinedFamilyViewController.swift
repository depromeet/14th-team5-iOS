//
//  JoinedFamilyViewController.swift
//  App
//
//  Created by geonhui Yu on 2/8/24.
//

import UIKit
import Core
import DesignSystem

import ReactorKit
import RxCocoa
import RxDataSources
import RxSwift
import SnapKit
import Then

fileprivate typealias _Str = JoinedFamilyStrings
final class JoinedFamilyViewController: BaseViewController<JoinedFamilyReactor> {
    private let titleLabel = BibbiLabel(.head1, textColor: .gray100)
    private let captionLabel = BibbiLabel(.body1Regular, textColor: .gray300)
    private let labelStack = UIStackView()
    
    private let imageView = UIImageView()
    
    private let showHomeButton = UIButton()
    private let showJoinedFamilyButton = UIButton()
    
    override func setupUI() {
        super.setupUI()
        
        view.addSubviews(titleLabel, captionLabel, imageView, showHomeButton, showJoinedFamilyButton)
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        
        titleLabel.do {
            $0.text = _Str.title
        }
        
        captionLabel.do {
            $0.text = _Str.caption
        }
        
        imageView.do {
            $0.image = DesignSystemAsset.joinedFamilyCharacter.image
            $0.contentMode = .scaleAspectFit
        }
        
        showHomeButton.do {
            $0.setTitle(_Str.homeBtnTitle, for: .normal)
            $0.titleLabel?.font = UIFont(font: DesignSystemFontFamily.Pretendard.semiBold, size: 16)
            $0.setTitleColor(DesignSystemAsset.black.color, for: .normal)
            $0.backgroundColor = DesignSystemAsset.mainYellow.color
            $0.layer.cornerRadius = 28
        }

        showJoinedFamilyButton.do {
            $0.setTitle(_Str.joinFamilyBtnTitle, for: .normal)
            $0.titleLabel?.font = UIFont(font: DesignSystemFontFamily.Pretendard.semiBold, size: 16)
            $0.setTitleColor(DesignSystemAsset.black.color, for: .normal)
            $0.backgroundColor = DesignSystemAsset.mainYellow.color
            $0.layer.cornerRadius = 28
        }
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
     
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(44)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        captionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        imageView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        showHomeButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.bottom.equalTo(showJoinedFamilyButton.snp.top).offset(-22)
            $0.height.equalTo(56)
        }
        
        showJoinedFamilyButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.height.equalTo(56)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-17)
        }
    }
    
    override func bind(reactor: JoinedFamilyReactor) {
        super.bind(reactor: reactor)
        
        showHomeButton.rx.tap
            .throttle(RxConst.throttleInterval, scheduler: MainScheduler.instance)
            .map { Reactor.Action.enterFamily }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        showJoinedFamilyButton.rx.tap
            .throttle(RxConst.throttleInterval, scheduler: MainScheduler.instance)
            .map { Reactor.Action.joinFamily }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isShowHome }
            .observe(on: Schedulers.main)
            .distinctUntilChanged()
            .withUnretained(self)
            .bind(onNext: { $0.0.showHomeViewController($0.1) })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isShowJoinFamily }
            .observe(on: Schedulers.main)
            .withUnretained(self)
            .bind(onNext: { $0.0.showInputLinkViewController($0.1) })
            .disposed(by: disposeBag)
    }
}

extension JoinedFamilyViewController {
    private func showHomeViewController(_ isShow: Bool) {
        guard isShow else { return }
        
        UserDefaults.standard.clearInviteCode()
        
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
        sceneDelegate.window?.rootViewController = UINavigationController(rootViewController: MainViewDIContainer().makeViewController())
        sceneDelegate.window?.makeKeyAndVisible()
    }
    
    private func showInputLinkViewController(_ isShow: Bool) {
        guard isShow else { return }
        let inputFamilyLinkViewController = InputFamilyLinkDIContainer().makeViewController()
        self.navigationController?.pushViewController(inputFamilyLinkViewController, animated: true)
    }
}
