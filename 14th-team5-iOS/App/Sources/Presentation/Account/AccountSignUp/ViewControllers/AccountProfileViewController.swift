//
//  AccountProfileViewController.swift
//  App
//
//  Created by geonhui Yu on 12/24/23.
//

import UIKit
import Core
import DesignSystem
import Domain
import PhotosUI

import ReactorKit
import RxSwift
import RxCocoa
import SnapKit
import Then

fileprivate typealias _Str = AccountSignUpStrings.Profile
final class AccountProfileViewController: BaseViewController<AccountSignUpReactor> {
    // MARK: SubViews
    private let titleLabel = BBLabel(.head2Bold, textAlignment: .center, textColor: .gray300)
    private let profileButton = UIButton()
    
    private var pickerConfiguration: PHPickerConfiguration = {
        var configuration: PHPickerConfiguration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        configuration.selection = .default
        return configuration
    }()
    private lazy var profilePickerController: PHPickerViewController = PHPickerViewController(configuration: pickerConfiguration)
    
    private let nextButton = UIButton()
    private let profileView = UIImageView()
    private let cameraView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePickerController.delegate = self
    }
    
    override func bind(reactor: AccountSignUpReactor) {
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: AccountSignUpReactor) {
        
        
        nextButton.rx.tap
            .throttle(RxConst.milliseconds300Interval, scheduler: RxSchedulers.main)
            .map { _ in Reactor.Action.didTapCompletehButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        profileButton.rx.tap
            .throttle(RxConst.milliseconds300Interval, scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { $0.0.createAlertController(owner: $0.0) })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(.AccountViewPresignURLDismissNotification)
            .compactMap { notification -> (String, Data)? in
                guard let userInfo = notification.userInfo,
                      let presignedURL = userInfo["presignedURL"] as? String,
                      let originalImage = userInfo["originImage"] as? Data else { return nil
                    }
                return (presignedURL, originalImage)
            }
            .map { Reactor.Action.profilePresignedURL($0.0, $0.1)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: AccountSignUpReactor) {
        reactor.state.map { $0.nickname }
            .withUnretained(self)
            .observe(on: RxSchedulers.main)
            .bind(onNext: { $0.0.setProfilewView(with: $0.1) })
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.profileImage }
            .map { UIImage(data: $0) }
            .bind(to: profileView.rx.image)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.didTapCompletehButtonFinish }
            .withUnretained(self)
            .observe(on: RxSchedulers.main)
            .bind(onNext: { $0.0.showNextPage(accessToken: $0.1) })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(.PHPickerAssetsDidFinishPickingProcessingPhotoNotification)
            .compactMap { notification -> Data? in
                guard let userInfo = notification.userInfo else { return nil }
                return userInfo["selectImage"] as? Data
            }
            .map{ Reactor.Action.didTapPHAssetsImage($0)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    override func setupUI() {
        super.setupUI()
        view.addSubviews(titleLabel, profileButton, profileView, cameraView, nextButton)
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview().inset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(130)
        }
        
        profileButton.snp.makeConstraints {
            $0.centerX.equalToSuperview().inset(20)
            $0.top.equalTo(titleLabel.snp.bottom).offset(26)
            $0.width.height.equalTo(90)
        }
        
        profileView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(26)
            $0.width.height.equalTo(90)
        }
        
        cameraView.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(35)
            $0.top.equalTo(titleLabel.snp.bottom).offset(90)
            $0.width.height.equalTo(28)
        }
        
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-10)
            $0.height.equalTo(56)
        }

    }
    
    override func setupAttributes() {
        titleLabel.do {
            $0.numberOfLines = 2
        }
        
        profileButton.do {
            $0.tintColor = DesignSystemAsset.gray200.color
            $0.backgroundColor = DesignSystemAsset.gray800.color
            $0.layer.cornerRadius = 45
        }
        
        profileView.do {
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 45
            $0.clipsToBounds = true
        }
        
        cameraView.do {
            $0.image = DesignSystemAsset.cameraCircle.image
            $0.contentMode = .scaleAspectFit
        }
        
        nextButton.do {
            $0.setTitle(_Str.buttonTitle, for: .normal)
            $0.titleLabel?.font = UIFont(font: DesignSystemFontFamily.Pretendard.semiBold, size: 16)
            $0.setTitleColor(DesignSystemAsset.black.color, for: .normal)
            $0.backgroundColor = DesignSystemAsset.mainYellow.color
            $0.layer.cornerRadius = 28
        }
        
    }
}

extension AccountProfileViewController {
    private func setProfilewView(with nickname: String) {
        titleLabel.text = String(format: _Str.title, nickname)
        
        if let firstName = nickname.first {
            profileButton.setTitle(String(firstName), for: .normal)
            profileButton.titleLabel?.font = UIFont(font: DesignSystemFontFamily.Pretendard.semiBold, size: 28)
        }
    }
    
    private func showNextPage(accessToken: AccessTokenResponse?) {
        @Navigator var accountProfileNavigator: AccountProfileNavigatorProtocol
        guard let accessToken = accessToken else { return }
        
        let token = accessToken.accessToken
        let refreshToken = accessToken.refreshToken
        let isTemporaryToken = accessToken.isTemporaryToken
        
        let tk = AccessToken(accessToken: token, refreshToken: refreshToken, isTemporaryToken: isTemporaryToken)
        App.Repository.token.accessToken.accept(tk)
        accountProfileNavigator.toOnboarding()
    }
}

extension AccountProfileViewController {
    private func createAlertController(owner: AccountProfileViewController) {
        let alertController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let presentCameraAction: UIAlertAction = UIAlertAction(title: "카메라", style: .default) { _ in
            let cameraViewController = CameraViewControllerWrapper(cameraType: .account).viewController
            owner.navigationController?.pushViewController(cameraViewController, animated: true)
        }
        let presentAlbumAction: UIAlertAction = UIAlertAction(title: "앨범", style: .default) { _ in
            self.profilePickerController.modalPresentationStyle = .fullScreen
            self.profilePickerController.overrideUserInterfaceStyle = .dark
            self.present(self.profilePickerController, animated: true)
        }
        let presentCancelAction: UIAlertAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        presentCancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        [presentCameraAction, presentAlbumAction, presentCancelAction].forEach { alertController.addAction($0) }
        alertController.overrideUserInterfaceStyle = .dark
        owner.present(alertController, animated: true)
    }
}

extension AccountProfileViewController: PHPickerViewControllerDelegate {
    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        let itemProvider = results.first?.itemProvider
        picker.dismiss(animated: true)
        if let imageProvider = itemProvider, imageProvider.canLoadObject(ofClass: UIImage.self) {
            imageProvider.loadObject(ofClass: UIImage.self) { image, error in
                guard let photoImage: UIImage = image as? UIImage,
                      let originalData: Data = photoImage.jpegData(compressionQuality: 1.0) else { return }
                imageProvider.didSelectProfileImageWithProcessing(photo: originalData, error: error)
            }
        }
    }
}
