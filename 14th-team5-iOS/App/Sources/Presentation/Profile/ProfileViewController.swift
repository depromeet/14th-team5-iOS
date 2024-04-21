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
  private lazy var profileSegementControl: BibbiSegmentedControl = BibbiSegmentedControl(isUpdated: true)
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
        view.addSubviews(profileView, profileLineView, profileSegementControl, profileFeedCollectionView, profileIndicatorView)
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
        
        navigationBarView.do {
            $0.setNavigationView(leftItem: .arrowLeft, centerItem: .label("활동"), rightItem: .setting)
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
       
       profileFeedCollectionView.snp.makeConstraints {
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
        
        
        NotificationCenter.default.rx
            .notification(.ProfileImageInitializationUpdate)
            .map { _ in Reactor.Action.didTapInitProfile }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        reactor.state
            .map { $0.isLoading }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            .drive(profileIndicatorView.rx.isHidden)
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
        
        
        
        profileView.profileNickNameButton
            .rx.tap
            .withLatestFrom(reactor.state.compactMap { $0.profileMemberEntity?.memberId })
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { $0.0.transitionNickNameViewController(memberId: $0.1)})
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isUser }
            .distinctUntilChanged()
            .bind(to: profileView.rx.isSetting)
            .disposed(by: disposeBag)
      
        profileSegementControl
            .survivalButton.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { Reactor.Action.didTapSegementControl(.survival) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
      
        profileSegementControl
            .missionButton.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { Reactor.Action.didTapSegementControl(.mission) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
      
      
      
      
        reactor
          .state.map { $0.feedType == .survival ? true : false }
          .distinctUntilChanged()
          .observe(on: MainScheduler.instance)
          .bind(to: profileSegementControl.rx.isSelected)
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
        
        profileFeedCollectionView.rx.itemSelected
            .withLatestFrom(reactor.pulse(\.$feedResultItem)) { indexPath, feedResultItem in
                return (indexPath, feedResultItem)
            }
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { Reactor.Action.didTapProfilePost($0.0, $0.1) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        Observable
            .combineLatest(
                reactor.pulse(\.$profileData),
                reactor.pulse(\.$selectedIndexPath)
            )
            .withUnretained(self)
            .filter { !$0.1.0.items.isEmpty }
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe {
                guard let indexPath = $0.1.1 else { return }
                let postListViewController = PostListsDIContainer().makeViewController(postLists: $0.1.0, selectedIndex: indexPath)
                $0.0.navigationController?.pushViewController(postListViewController, animated: true)
            }.disposed(by: disposeBag)

        reactor.state
            .compactMap { $0.profileMemberEntity?.dayOfBirth }
            .distinctUntilChanged()
            .map { $0.isBirthDay }
            .bind(to: profileView.rx.isBirthDay)
            .disposed(by: disposeBag)
            
        
        reactor.state
            .compactMap { $0.profilePostEntity?.results.isEmpty }
            .map { !$0 }
            .bind(to: profileFeedCollectionView.rx.isScrollEnabled)
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
            .withUnretained(self)
            .bind { owner, entity in
                let profileDetailViewController = ProfileDetailDIContainer(profileURL: entity.memberImage, userNickname: entity.memberName).makeViewController()
                owner.navigationController?.pushViewController(profileDetailViewController, animated: false)
            }.disposed(by: disposeBag)
        
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
    
        navigationBarView.rx.rightButtonTap
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
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
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
