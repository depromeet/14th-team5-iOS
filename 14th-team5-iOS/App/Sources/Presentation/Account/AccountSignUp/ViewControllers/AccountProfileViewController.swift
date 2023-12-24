//
//  AccountProfileViewController.swift
//  App
//
//  Created by geonhui Yu on 12/24/23.
//

import UIKit
import Core
import DesignSystem

import ReactorKit
import RxSwift
import RxCocoa
import SnapKit
import Then

final class AccountProfileViewController: BaseViewController<AccountSignUpReactor> {
    // MARK: SubViews
    private let titleLabel = UILabel()
    private let profileButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind(reactor: AccountSignUpReactor) {
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: AccountSignUpReactor) {
        profileButton.rx.tap
            .throttle(RxConst.throttleInterval, scheduler: Schedulers.main)
            .withUnretained(self)
            .bind(onNext: { $0.0.createAlertController(owner: $0.0) })
            .disposed(by: self.disposeBag)
    }
    
    private func bindOutput(reactor: AccountSignUpReactor) {
//        reactor.state.map { $0.isValidNickname }
//            .distinctUntilChanged()
//            .withUnretained(self)
//            .bind(onNext: { $0.0.validationNickname($0.1) })
//            .disposed(by: self.disposeBag)
    }
    
    override func setupUI() {
        super.setupUI()
        
        view.addSubviews(titleLabel, profileButton)
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview().inset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(190)
        }
        
        profileButton.snp.makeConstraints {
            $0.centerX.equalToSuperview().inset(20)
            $0.top.equalTo(titleLabel.snp.bottom).offset(26)
            $0.width.height.equalTo(90)
        }
    }
    
    override func setupAttributes() {
        titleLabel.do {
            $0.font = UIFont(font: DesignSystemFontFamily.Pretendard.semiBold, size: 18)
            $0.textColor = DesignSystemAsset.gray300.color
            $0.numberOfLines = 2
            $0.text = "마지막이에요.\n엄마님의 프로필을 선택해보세요"
        }
        
        profileButton.do {
            $0.setTitle("엄", for: .normal)
            $0.tintColor = DesignSystemAsset.gray200.color
            $0.backgroundColor = DesignSystemAsset.gray800.color
            $0.layer.cornerRadius = 45
        }
    }
}


extension AccountProfileViewController {
    
    private func createAlertController(owner: AccountProfileViewController) {
        let alertController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let presentCameraAction: UIAlertAction = UIAlertAction(title: "카메라", style: .default) { _ in
            let cameraViewController = CameraDIContainer().makeViewController()
            owner.navigationController?.pushViewController(cameraViewController, animated: true)
        }
        
        let presentAlbumAction: UIAlertAction = UIAlertAction(title: "앨범", style: .default) { _ in
            print("이미지 피커 컨트롤러")
        }
        
        let presentDefaultAction: UIAlertAction = UIAlertAction(title: "초기화", style: .destructive) { _ in
            print("초기화 구문")
        }
        
        let presentCancelAction: UIAlertAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        [presentCameraAction, presentAlbumAction, presentDefaultAction, presentCancelAction].forEach {
            alertController.addAction($0)
        }
        
        owner.present(alertController, animated: true)
    }
    
}
