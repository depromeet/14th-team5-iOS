//
//  ProfileViewController.swift
//  App
//
//  Created by Kim dohyun on 12/17/23.
//

import UIKit

import Core
import DesignSystem
import Kingfisher
import PhotosUI
import RxSwift
import RxCocoa
import ReactorKit
import RxDataSources
import SnapKit
import Then


public final class ProfileViewController: BaseViewController<ProfileViewReactor> {

    
    //MARK: Views
  private lazy var profileSegementControl: BibbiSegmentedControl = BibbiSegmentedControl()
    private var pickerConfiguration: PHPickerConfiguration = {
        var configuration: PHPickerConfiguration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        configuration.selection = .default
        return configuration
    }()
    private let profileIndicatorView: BlurAiraplaneLottieView = BlurAiraplaneLottieView()
    private lazy var profileView: BibbiProfileView = BibbiProfileView(cornerRadius: 50)
    private let profileLineView: UIView = UIView()
    private lazy var profilePickerController: PHPickerViewController = PHPickerViewController(configuration: pickerConfiguration)

    private lazy var profileFeedViewController: ProfileFeedPageViewController = ProfileFeedPageViewControllerWrapper(memberId: reactor?.currentState.memberId ?? "").viewController
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.profileIndicatorView.isHidden = false
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.profileIndicatorView.isHidden = true
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func setupUI() {
        super.setupUI()
        
        addChild(profileFeedViewController)
        //TODO: - Test Code 추후 제거
        view.addSubviews(profileView, profileLineView, profileFeedViewController.view, profileSegementControl, profileIndicatorView)
        profileFeedViewController.didMove(toParent: self)
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        
        profilePickerController.do {
            $0.delegate = self
        }
        
        profileLineView.do {
            $0.backgroundColor = .separator
        }
        
        navigationBarView.do {
            $0.setNavigationView(leftItem: .arrowLeft, centerItem: .label("활동"), rightItem: .setting)
        }
        
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        profileView.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(profileLineView.snp.top)
        }
        
        profileLineView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.left.right.equalToSuperview()
            $0.top.equalTo(profileView.snp.bottom).offset(24)
        }
      
        profileSegementControl.snp.makeConstraints {
            $0.top.equalTo(profileLineView.snp.bottom).offset(20)
            $0.height.equalTo(40)
            $0.width.equalTo(140)
            $0.centerX.equalTo(profileView)
        }
        
        profileFeedViewController.view.snp.makeConstraints {
            $0.top.equalTo(profileSegementControl.snp.bottom).offset(20)
            $0.left.right.bottom.equalToSuperview()
        }
        
        profileIndicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    
    public override func bind(reactor: ProfileViewReactor) {
        super.bind(reactor: reactor)
        
        Observable.just(())
            .map { Reactor.Action.viewDidLoad}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        self.rx.viewWillAppear
            .map { _ in Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.rx.viewDidDisappear
            .map { _ in Reactor.Action.viewDidDisappear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        profileView.circleButton
            .rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: {$0.0.createAlertController()})
            .disposed(by: disposeBag)
        
        
        NotificationCenter.default.rx.notification(.PHPickerAssetsDidFinishPickingProcessingPhotoNotification)
            .compactMap { notification -> Data? in
                guard let userInfo = notification.userInfo else { return nil }
                return userInfo["selectImage"] as? Data
            }
            .distinctUntilChanged()
            .map { Reactor.Action.didSelectPHAssetsImage($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        NotificationCenter.default.rx
            .notification(.ProfileImageInitializationUpdate)
            .map { _ in Reactor.Action.didTapInitProfile }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        reactor.state
            .map { $0.isLoading }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: true)
            .drive(profileIndicatorView.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$profileMemberEntity)
            .compactMap { $0 }
            .map { $0.memberName }
            .withUnretained(self)
            .bind(onNext: { $0.0.setupProfileButton(title: $0.1)})
            .disposed(by: disposeBag)
        
        profileView.profileNickNameButton
            .rx.tap
            .withLatestFrom(reactor.state.compactMap { $0.profileMemberEntity?.memberId })
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { Reactor.Action.didTappedProfileEditButton($0)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isUser }
            .distinctUntilChanged()
            .bind(to: profileView.rx.isSetting)
            .disposed(by: disposeBag)
        
        reactor
          .state.map { $0.feedType == .survival ? true : false }
          .distinctUntilChanged()
          .observe(on: MainScheduler.instance)
          .bind(to: profileSegementControl.rx.isSelected)
          .disposed(by: disposeBag)
        
        profileSegementControl
            .missionButton.rx.tap
            .throttle(.milliseconds(100), scheduler: MainScheduler.instance)
            .map { Reactor.Action.didTapSegementControl(.mission) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        profileSegementControl
            .survivalButton.rx.tap
            .throttle(.milliseconds(100), scheduler: MainScheduler.instance)
            .map { Reactor.Action.didTapSegementControl(.survival) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
      
        
        
        reactor.pulse(\.$profileMemberEntity)
            .filter { $0?.memberImage.isFileURL == false }
            .compactMap { $0?.memberImage }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { $0.0.setupProfileImage(url: $0.1)})
            .disposed(by: disposeBag)
        
        
        reactor.pulse(\.$profileMemberEntity)
            .compactMap { $0?.memberImage.isFileURL }
            .observe(on: MainScheduler.instance)
            .bind(to: profileView.rx.isDefault)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$profileMemberEntity)
            .filter { $0?.memberImage.isFileURL ?? false }
            .compactMap { $0?.memberName.first }
            .compactMap { "\($0)"}
            .bind(to: profileView.profileDefaultLabel.rx.text)
            .disposed(by: disposeBag)
        

        reactor.state
            .compactMap { $0.profileMemberEntity?.dayOfBirth }
            .distinctUntilChanged()
            .map { $0.isBirthDay }
            .bind(to: profileView.rx.isBirthDay)
            .disposed(by: disposeBag)
            
        
        reactor.state
            .compactMap { $0.profileMemberEntity}
            .map { "\($0.familyJoinAt) 가입" }
            .bind(to: profileView.profileCreateLabel.rx.text)
            .disposed(by: disposeBag)
        
        profileView.profileImageView
            .rx.tap
            .throttle(.microseconds(300), scheduler: MainScheduler.instance)
            .withLatestFrom(reactor.state.compactMap { $0.profileMemberEntity } )
            .map { Reactor.Action.didTappedProfileImageView($0.memberImage, $0.memberName)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
    
        navigationBarView.rx.rightButtonTap
            .withLatestFrom(reactor.state.map { $0.memberId })
            .throttle(.microseconds(300), scheduler: MainScheduler.instance)
            .map { Reactor.Action.didTappedNavigationButton($0)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

// 기본 이미지가 true 이고 닉네임 변경 할 경우 redraw
extension ProfileViewController {    
    private func setupProfileImage(url: URL) {
        let processor = DownsamplingImageProcessor(size: profileView.bounds.size)
        
        profileView
            .profileImageView
            .kf
            .setImage(with: url, options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(0.5))
            ])
    }
    
    
    private func setupProfileButton(title: String) {
        profileView.profileNickNameButton.setAttributedTitle(NSAttributedString(string: title, attributes: [
            .foregroundColor: DesignSystemAsset.gray200.color,
            .font: DesignSystemFontFamily.Pretendard.semiBold.font(size: 16),
            .kern: -0.3,
        ]), for: .normal)
    }
    
    private func createAlertController() {
        let alertController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let presentCameraAction: UIAlertAction = UIAlertAction(title: "카메라", style: .default) { _ in
            guard let profileMemberId = self.reactor?.currentState.profileMemberEntity?.memberId else { return }
            
            self.reactor?.action.onNext(.didTappedAlertButton(profileMemberId))
        }
        
        let presentAlbumAction: UIAlertAction = UIAlertAction(title: "앨범", style: .default) { _ in
            self.profilePickerController.modalPresentationStyle = .fullScreen
            self.profilePickerController.overrideUserInterfaceStyle = .dark
            self.present(self.profilePickerController, animated: true)
        }
        
        let presentDefaultAction: UIAlertAction = UIAlertAction(title: "초기화", style: .destructive) {  _ in
            
            
            NotificationCenter.default.post(name: .ProfileImageInitializationUpdate, object: nil, userInfo: nil)
        }
        
        let presentCancelAction: UIAlertAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        [presentCameraAction, presentAlbumAction, presentDefaultAction, presentCancelAction].forEach {
            alertController.addAction($0)
        }
        alertController.overrideUserInterfaceStyle = .dark
        self.present(alertController, animated: true)
    }
    
}

extension ProfileViewController: PHPickerViewControllerDelegate {
    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        let itemProvider = results.first?.itemProvider
        picker.dismiss(animated: true, completion: nil)
        
        if let imageProvider = itemProvider, imageProvider.canLoadObject(ofClass: UIImage.self) {
            imageProvider.loadObject(ofClass: UIImage.self) { image, error in
                guard let photoImage: UIImage = image as? UIImage,
                      let originalData: Data = photoImage.jpegData(compressionQuality: 1.0) else { return }
                imageProvider.didSelectProfileImageWithProcessing(photo: originalData, error: error)
            }
            
        }
    }
}
