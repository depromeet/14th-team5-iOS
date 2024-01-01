//
//  ProfileViewController.swift
//  App
//
//  Created by Kim dohyun on 12/17/23.
//

import UIKit

import Core
import Data
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

    
    private var pickerConfiguration: PHPickerConfiguration = {
        var configuration: PHPickerConfiguration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        configuration.selection = .default
        return configuration
    }()
    
    //MARK: Views

    private let profileIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
    private lazy var profileView: BibbiProfileView = BibbiProfileView(cornerRadius: 50)
    private let profileNavigationBar: BibbiNavigationBarView = BibbiNavigationBarView()
    private let profileLineView: UIView = UIView()
    private lazy var profilePickerController: PHPickerViewController = PHPickerViewController(configuration: pickerConfiguration)
    private let profileFeedCollectionViewLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private lazy var profileFeedCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: profileFeedCollectionViewLayout)
    private let profileFeedDataSources: RxCollectionViewSectionedReloadDataSource<ProfileFeedSectionModel> = .init { dataSources, collectionView, indexPath, sectionItem in
        switch sectionItem {
        case let .feedCategoryItem(cellReactor):
            guard let profileFeedCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileFeedCollectionViewCell", for: indexPath) as? ProfileFeedCollectionViewCell else { return UICollectionViewCell() }
            profileFeedCell.reactor = cellReactor
            return profileFeedCell
            
        case let .feedCateogryEmptyItem(cellReactor):
            guard let profileFeedEmptyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileFeedEmptyCollectionViewCell", for: indexPath) as? ProfileFeedEmptyCollectionViewCell else { return UICollectionViewCell() }
            profileFeedEmptyCell.reactor = cellReactor
            return profileFeedEmptyCell
        }
    }

    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func setupUI() {
        super.setupUI()
        view.addSubviews(profileView, profileLineView, profileFeedCollectionView, profileIndicatorView, profileNavigationBar)
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        
        profileFeedCollectionViewLayout.do {
            $0.scrollDirection = .vertical
        }
        
        profilePickerController.do {
            $0.delegate = self
        }
        
        profileLineView.do {
            $0.backgroundColor = .separator
        }
        
        profileNavigationBar.do {
            $0.navigationTitle = "활동"
            $0.leftBarButtonItem = .arrowLeft
            $0.rightBarButtonItem = .setting
            $0.leftBarButtonItemTintColor = .gray300
            $0.rightBarButtonItemTintColor = .gray400
        }
        
        profileIndicatorView.do {
            $0.hidesWhenStopped = true
            $0.color = .gray
        }
        
        profileFeedCollectionView.do {
            $0.register(ProfileFeedCollectionViewCell.self, forCellWithReuseIdentifier: "ProfileFeedCollectionViewCell")
            $0.register(ProfileFeedEmptyCollectionViewCell.self, forCellWithReuseIdentifier: "ProfileFeedEmptyCollectionViewCell")
            $0.showsVerticalScrollIndicator = true
            $0.showsHorizontalScrollIndicator = false
            $0.backgroundColor = .clear
        }
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        
        profileNavigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(42)
        }
        
        profileView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(200)
        }
        
        
        profileLineView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.left.right.equalToSuperview()
            $0.top.equalTo(profileView.snp.bottom).offset(24)
        }
        
        profileFeedCollectionView.snp.makeConstraints {
            $0.top.equalTo(profileLineView.snp.bottom).offset(1)
            $0.left.right.bottom.equalToSuperview()
        }
        
        profileIndicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    
    public override func bind(reactor: ProfileViewReactor) {

        Observable.just(())
            .map { Reactor.Action.viewDidLoad}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.rx.viewWillAppear
            .map { _ in Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        profileFeedCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        
        profileView.circleButton
            .rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: {$0.0.createAlertController(owner: $0.0)})
            .disposed(by: disposeBag)
        
            
        NotificationCenter.default.rx.notification(.PHPickerAssetsDidFinishPickingProcessingPhotoNotification)
            .compactMap { notification -> Data? in
                guard let userInfo = notification.userInfo else { return nil }
                return userInfo["selectImage"] as? Data
            }
            .map { Reactor.Action.didSelectPHAssetsImage($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
            
        
        reactor.state
            .map { $0.isLoading }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            .drive(profileIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$feedSection)
            .asDriver(onErrorJustReturn: [])
            .drive(profileFeedCollectionView.rx.items(dataSource: profileFeedDataSources))
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$profileMemberEntity)
            .compactMap { $0 }
            .map { $0.memberName }
            .withUnretained(self)
            .bind(onNext: { $0.0.setupProfileButton(title: $0.1)})
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$profileMemberEntity)
            .compactMap { $0 }
            .map { $0.memberImage }
            .withUnretained(self)
            .bind(onNext: { $0.0.setupProfileImage($0.1)})
            .disposed(by: disposeBag)
        
        profileView.profileNickNameButton
            .rx.tap
            .withLatestFrom(reactor.state.compactMap { $0.profileMemberEntity?.memberId })
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { $0.0.transitionNickNameViewController(memberId: $0.1)})
            .disposed(by: disposeBag)
        
        
        reactor.state
            .compactMap { $0.profilePostEntity?.results.isEmpty }
            .map { !$0 }
            .bind(to: profileFeedCollectionView.rx.isScrollEnabled)
            .disposed(by: disposeBag)
        
        profileFeedCollectionView.rx
            .didScroll
            .withLatestFrom(profileFeedCollectionView.rx.contentOffset)
            .withUnretained(self)
            .map {
                let contentPadding = $0.0.profileFeedCollectionView.contentSize.height - $0.1.y
                if contentPadding < UIScreen.main.bounds.height {
                    return true
                } else {
                    return false
                }
            }
            .distinctUntilChanged()
            .map { Reactor.Action.fetchMorePostItems($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        profileNavigationBar.rx.didTapLeftBarButton
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }.disposed(by: disposeBag)
        
        profileNavigationBar.rx.didTapRightBarButton
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .withLatestFrom(reactor.state.map { $0.memberId })
            .withUnretained(self)
            .bind { owner, memberId in
                let privacyViewController = PrivacyDIContainer(memberId: memberId).makeViewController()
                owner.navigationController?.pushViewController(privacyViewController, animated: true)
            }.disposed(by: disposeBag)
    }
}


extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch profileFeedDataSources[indexPath] {
        case .feedCategoryItem:
            return CGSize(width: (collectionView.frame.size.width / 2) - 4, height: 243)
        case .feedCateogryEmptyItem:
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        }
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
}


extension ProfileViewController {
    private func setupProfileImage(_ url: URL) {
        profileView.profileImageView.kf.setImage(with: url)
    }
    
    private func setupProfileButton(title: String) {
        profileView.profileNickNameButton.configuration?.attributedTitle = AttributedString(NSAttributedString(string: title, attributes: [
            .foregroundColor: DesignSystemAsset.gray200.color,
            .font: DesignSystemFontFamily.Pretendard.bold.font(size: 16)
        ]))
        
    }
    
    private func transitionNickNameViewController(memberId: String) {
        let accountNickNameViewController:AccountNicknameViewController = AccountSignUpDIContainer(memberId: memberId, accountType: .profile).makeNickNameViewController()
        self.navigationController?.pushViewController(accountNickNameViewController, animated: false)
    }
    
    private func createAlertController(owner: ProfileViewController) {
        let alertController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let presentCameraAction: UIAlertAction = UIAlertAction(title: "카메라", style: .default) { _ in
            guard let profileMemberId = self.reactor?.currentState.profileMemberEntity?.memberId else { return }
            
            let cameraViewController = CameraDIContainer(cameraType: .profile, memberId: profileMemberId).makeViewController()
            owner.navigationController?.pushViewController(cameraViewController, animated: true)
        }
        
        let presentAlbumAction: UIAlertAction = UIAlertAction(title: "앨범", style: .default) { _ in
            self.profilePickerController.modalPresentationStyle = .fullScreen
            self.present(self.profilePickerController, animated: true)
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
