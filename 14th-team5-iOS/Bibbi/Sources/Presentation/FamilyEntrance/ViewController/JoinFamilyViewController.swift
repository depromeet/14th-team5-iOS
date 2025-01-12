//
//  JoinFamilyViewController.swift
//  App
//
//  Created by 마경미 on 12.01.24.
//

import UIKit

import Core
import DesignSystem
import Util

import ReactorKit
import RxCocoa
import RxDataSources
import RxSwift
import SnapKit
import Then

fileprivate typealias _Str = JoinFamilyStrings
final class JoinFamilyViewController: BaseViewController<JoinFamilyReactor> {
    // MARK: - Views
    private let titleLabel: BBLabel = BBLabel(.head1, textColor: .gray100)
    private let joinFamilyButton: InviteFamilyView = InviteFamilyView(openType: .inviteUrl)
    private let makeFamilyButton: MakeNewFamilyView = MakeNewFamilyView()
    
    override func setupUI() {
        super.setupUI()
        view.addSubviews(titleLabel, makeFamilyButton, joinFamilyButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(44)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(66)
        }
        
        joinFamilyButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(90)
        }
        
        makeFamilyButton.snp.makeConstraints {
            $0.top.equalTo(joinFamilyButton.snp.bottom).offset(24)
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
        
        makeFamilyButton.do {
            $0.layer.cornerRadius = 16
        }
    }
    
    override func bind(reactor: JoinFamilyReactor) {
        super.bind(reactor: reactor)
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: JoinFamilyReactor) {
        makeFamilyButton.rx.tap
            .do(onNext: {
                MPEvent.Account.creatGroup.track(with: nil)
                BBLogManager.analytics(logType: BBEventAnalyticsLog.clickFamilyButton(entry: .createFamilyGroup))
            })
            .throttle(RxConst.milliseconds300Interval, scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { $0.0.newGroupAlertController()})
            .disposed(by: disposeBag)
        
        joinFamilyButton.rx.tap
            .do { _ in BBLogManager.analytics(logType: BBEventAnalyticsLog.clickFamilyButton(entry: .inviteFamily)) }
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
        @Navigator var joinFamilyNavigator: JoinFamilyNavigatorProtocol
        
        UserDefaults.standard.clearInviteCode()
        joinFamilyNavigator.toMain()
    }
    
    private func showInputLinkViewController(_ isShow: Bool) {
        guard isShow else { return }
        
        let inputFamilyLinkViewController = InputFamilyLinkDIContainer().makeViewController()
        self.navigationController?.pushViewController(inputFamilyLinkViewController, animated: true)
    }
    
    private func newGroupAlertController() {
        let resignAlertController = UIAlertController(
            title: "새 그룹방으로 입장",
            message: "초대 받은 그룹이 없어\n새 그룹방으로 입장할래요",
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            guard let self else { return }
            MPEvent.Account.creatGroupFinished.track(with: nil)
            self.reactor?.action.onNext(.makeFamily)
        }
        
        [cancelAction, confirmAction].forEach(resignAlertController.addAction(_:))
        
        resignAlertController.overrideUserInterfaceStyle = .dark
        present(resignAlertController, animated: true)
    }
}
