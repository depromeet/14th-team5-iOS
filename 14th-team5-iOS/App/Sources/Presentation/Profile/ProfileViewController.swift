//
//  ProfileViewController.swift
//  App
//
//  Created by Kim dohyun on 12/17/23.
//

import UIKit

import Core
import DesignSystem
import RxSwift
import RxCocoa
import ReactorKit
import RxDataSources
import SnapKit
import Then


public final class ProfileViewController: BaseViewController<ProfileViewReactor> {
    //MARK: Views
    private let profileIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
    private let profileViewReactor: BibbiProfileViewReactor = BibbiProfileViewReactor()
    private lazy var profileView: BibbiProfileView = BibbiProfileView(cornerRadius: 60, reactor: profileViewReactor)
    private let profileTitleView: UILabel = UILabel()
    private let privacyButton: UIButton = UIButton()
    private let profileLineView: UIView = UIView()
    private let profileFeedCollectionViewLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private lazy var profileFeedCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: profileFeedCollectionViewLayout)
    private let profileFeedDataSources: RxCollectionViewSectionedReloadDataSource<ProfileFeedSectionModel> = .init { dataSources, collectionView, indexPath, sectionItem in
        switch sectionItem {
        case let .feedCategoryItem(cellReactor):
            guard let profileFeedCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileFeedCollectionViewCell", for: indexPath) as? ProfileFeedCollectionViewCell else { return UICollectionViewCell() }
            profileFeedCell.reactor = cellReactor
            return profileFeedCell
        }
    }

    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func setupUI() {
        super.setupUI()
        view.addSubviews(profileView, profileLineView, profileFeedCollectionView, profileIndicatorView)
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        
        profileFeedCollectionViewLayout.do {
            $0.scrollDirection = .vertical
        }
        
        profileTitleView.do {
            $0.textColor = .white
            $0.text = "활동"
        }
        
        profileLineView.do {
            $0.backgroundColor = .separator
        }
        
//        privacyButton.do {
//            $0.setImage(DesignSystemAsset.privacy.image, for: .normal)
//        }
        
        navigationItem.do {
            $0.titleView = profileTitleView
            $0.rightBarButtonItem = UIBarButtonItem(customView: privacyButton)
        }
        
        profileIndicatorView.do {
            $0.hidesWhenStopped = true
            $0.color = .gray
        }
        
        profileFeedCollectionView.do {
            $0.register(ProfileFeedCollectionViewCell.self, forCellWithReuseIdentifier: "ProfileFeedCollectionViewCell")
            $0.showsVerticalScrollIndicator = true
            $0.showsHorizontalScrollIndicator = false
            $0.backgroundColor = .clear
        }
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        
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
        
        profileFeedCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        privacyButton
            .rx.tap
            .throttle(.microseconds(300), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { owner, _ in
                let privacyViewController = PrivacyDIContainer().makeViewController()
                owner.navigationController?.pushViewController(privacyViewController, animated: true)
            }.disposed(by: disposeBag)
        
        profileView.circleButton
            .rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: {$0.0.createAlertController(owner: $0.0)})
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
        
    }
}


extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width / 2) - 4, height: 243)
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
    
    private func createAlertController(owner: ProfileViewController) {
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
