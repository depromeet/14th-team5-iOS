//
//  SplashViewController.swift
//  App
//
//  Created by 김건우 on 1/4/24.
//

import UIKit
import Core
import DesignSystem
import Domain
import RxSwift
import RxCocoa
import SnapKit
import Then

public final class SplashViewController: BaseViewController<SplashReactor> {
    // MARK: - Views
    private let bibbiImageView = UIImageView()
    
    // MARK: - LifeCycles
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = DesignSystemAsset.mainYellow.color
    }
    
    // MARK: - Helpers
    override public func setupUI() {
        super.setupUI()
        
        view.addSubviews(bibbiImageView)
    }
    
    override public func setupAttributes() {
        super.setupAttributes()
        
        bibbiImageView.do {
            $0.image = UIImage(named: "splash")
            $0.contentMode = .scaleAspectFit
        }
    }
    
    override public func setupAutoLayout() {
        super.setupAutoLayout()
        
        bibbiImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override public func bind(reactor: SplashReactor) {
        Observable.just(())
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        NotificationCenter.default
            .rx.notification(.didTapUpdateButton)
            .withUnretained(self)
            .bind(onNext: { $0.0.openAppStore() })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$updatedNeeded)
            .skip(1)
            .filter { $0 == nil }
            .withUnretained(self)
            .observe(on: RxSchedulers.main)
            .bind(onNext: { $0.0.showUpdateAlert($0.1) })
            .disposed(by: disposeBag)
    }
    
    private func openAppStore() {
        let appStoreURL = URLTypes.appStore.originURL
        if UIApplication.shared.canOpenURL(appStoreURL) {
            UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
        }
    }
    
    private func showUpdateAlert(_ appVersionInfo: AppVersionInfo?) {
        let updateAlertController = UIAlertController(
            title: "업데이트가 필요해요",
            message: "더 나은 삐삐를 위해\n업데이트를 부탁드려요.",
            preferredStyle: .alert
        )
        
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            NotificationCenter.default.post(name: .didTapUpdateButton, object: nil, userInfo: nil)
        }
        
        [confirmAction].forEach(updateAlertController.addAction(_:))
        
        updateAlertController.overrideUserInterfaceStyle = .dark
        present(updateAlertController, animated: true)
    }
}
