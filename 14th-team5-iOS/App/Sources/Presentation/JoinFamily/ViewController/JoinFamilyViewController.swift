//
//  JoinFamilyViewController.swift
//  App
//
//  Created by 마경미 on 12.01.24.
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

fileprivate typealias _Str = JoinFamilyStrings
final class JoinFamilyViewController: BaseViewController<JoinFamilyReactor> {
    // MARK: - Views
    private let titleLabel: BibbiLabel = BibbiLabel(.head1, textColor: .gray100)
    private let captionLabel: BibbiLabel = BibbiLabel(.body1Regular, textColor: .gray300)
    private let createFamilyButton: UIButton = UIButton()
    private let joinFamilyButton: InviteFamilyView = InviteFamilyView(openType: .inviteUrl)
    
    override func setupUI() {
        super.setupUI()
        view.addSubviews(titleLabel, captionLabel, createFamilyButton, joinFamilyButton)
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(66)
        }
        
        captionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(24)
        }
        
        createFamilyButton.snp.makeConstraints {
            $0.top.equalTo(captionLabel.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(createFamilyButton.snp.width)
        }
        
        joinFamilyButton.snp.makeConstraints {
            $0.top.equalTo(createFamilyButton.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(90)
        }
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        
        titleLabel.do {
            $0.text = _Str.mainTitle
            $0.numberOfLines = 2
        }
        
        captionLabel.do {
            $0.text = _Str.caption
        }
        
        createFamilyButton.do {
            $0.setImage(DesignSystemAsset.makeGroupButton.image, for: .normal)
        }
    }
    
    override func bind(reactor: JoinFamilyReactor) {
        super.bind(reactor: reactor)
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: JoinFamilyReactor) {
        createFamilyButton.rx.tap
            .map { Reactor.Action.makeFamily }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        joinFamilyButton.rx.tap
            .map { Reactor.Action.joinFamily }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: JoinFamilyReactor) {
        reactor.state
            .map { $0.isShowHome }
            .observe(on: MainScheduler.instance)
            .distinctUntilChanged()
            .withUnretained(self)
            .bind(onNext: { $0.0.showHomeViewController($0.1) })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isShowJoinFamily }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { $0.0.showInputLinkViewController($0.1) })
            .disposed(by: disposeBag)
    }
}

extension JoinFamilyViewController {
    private func showHomeViewController(_ isShow: Bool) {
        guard isShow else { return }
        
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
        sceneDelegate.window?.rootViewController = UINavigationController(rootViewController: HomeDIContainer().makeViewController())
        sceneDelegate.window?.makeKeyAndVisible()
    }
    
    private func showInputLinkViewController(_ isShow: Bool) {
        guard isShow else { return }
        
        let inputFamilyLinkViewController = InputFamilyLinkDIContainer().makeViewController()
        self.navigationController?.pushViewController(inputFamilyLinkViewController, animated: true)
    }
}
