//
//  CameraDisplayViewController.swift
//  App
//
//  Created by Kim dohyun on 12/11/23.
//

import UIKit

import Core
import DesignSystem
import Photos
import RxDataSources
import RxSwift
import RxCocoa
import ReactorKit
import SnapKit


public final class CameraDisplayViewController: BaseViewController<CameraDisplayViewReactor> {
    //MARK: Views
    private let displayView: UIImageView = UIImageView()
    private let confirmButton: UIButton = UIButton(configuration: .plain())
    private let displayIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
    private let displayNavigationBar: BibbiNavigationBarView = BibbiNavigationBarView()
    private let backButton: UIButton = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 52, height: 52)))
    private let titleView: BibbiLabel = BibbiLabel(.head2Bold, textColor: .gray200)
    private let displayEditButton: UIButton = UIButton.createCircleButton(radius: 21.5)
    private let displayEditTextField: UITextField = UITextField()
    private let displayDimView: UIView = UIView()
    private let archiveButton: UIButton = UIButton.createCircleButton(radius: 24)
    private var displayEditCollectionViewLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private lazy var  displayEditCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: displayEditCollectionViewLayout)
    private let displayEditDataSources: RxCollectionViewSectionedReloadDataSource<DisplayEditSectionModel> = .init { dataSources, collectionView, indexPath, sectionItem in
        switch sectionItem {
        case let .fetchDisplayItem(cellReactor):
            guard let displayEditCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DisplayEditCollectionViewCell", for: indexPath) as? DisplayEditCollectionViewCell else { return UICollectionViewCell() }
            displayEditCell.reactor = cellReactor
            return displayEditCell
        }
    }
    
    //MARK: LifeCylce
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Configure
    public override func setupUI() {
        super.setupUI()
        view.addSubviews(displayView, confirmButton, archiveButton, displayIndicatorView, displayEditTextField, displayEditCollectionView, displayNavigationBar)
        displayView.addSubviews(displayEditButton)
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        
        displayEditCollectionViewLayout.do {
            $0.itemSize = CGSize(width: 38, height: 61)
            $0.minimumInteritemSpacing = 4
        }
        
        displayNavigationBar.do {
            $0.navigationTitle = "사진 올리기"
            $0.leftBarButtonItem = .arrowLeft
            $0.leftBarButtonItemTintColor = .gray300
        }
        
        archiveButton.do {
            $0.setImage(DesignSystemAsset.archive.image, for: .normal)
            $0.backgroundColor = .darkGray
        }
        
        displayView.do {
            $0.layer.cornerRadius = 40
            $0.clipsToBounds = true
            $0.isUserInteractionEnabled = true
        }
        
        displayEditButton.do {
            $0.setImage(DesignSystemAsset.blurTextFill.image, for: .normal)
            $0.setTitleColor(.white, for: .normal)
        }
        
        confirmButton.do {
            $0.configuration?.imagePlacement = .leading
            $0.backgroundColor = DesignSystemAsset.mainGreen.color
            $0.configuration?.image = DesignSystemAsset.camera.image.withTintColor(DesignSystemAsset.black.color)
            $0.configuration?.imagePadding = 6
            $0.configuration?.attributedTitle = AttributedString(NSAttributedString(string: "사진 업로드", attributes: [
                .foregroundColor: DesignSystemAsset.black.color,
                .font: DesignSystemFontFamily.Pretendard.bold.font(size: 16)
            ]))
            $0.isUserInteractionEnabled = true
            $0.layer.cornerRadius = 30
            $0.clipsToBounds = true

        }
        
        displayEditTextField.do {
            $0.textColor = DesignSystemAsset.white.color
            $0.backgroundColor = DesignSystemAsset.black.color
            $0.font = DesignSystemFontFamily.Pretendard.regular.font(size: 17)
            $0.makeLeftPadding(16)
            $0.makeClearButton(DesignSystemAsset.clear.image)
            $0.makePlaceholderAttributedString("최대 8글자 이내로 입력해주세요.", attributed: [
                .font: DesignSystemFontFamily.Pretendard.regular.font(size: 17),
                .foregroundColor: DesignSystemAsset.gray500.color
            ])
            $0.keyboardType = .default
            $0.returnKeyType = .done
            $0.keyboardAppearance = .dark
            $0.borderStyle = .none
            $0.clearButtonMode = .whileEditing
            $0.isHidden = true
        }
        
        displayEditCollectionView.do {
            $0.register(DisplayEditCollectionViewCell.self, forCellWithReuseIdentifier: "DisplayEditCollectionViewCell")
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.backgroundColor = .clear
            $0.isScrollEnabled = false
        }
        
        displayIndicatorView.do {
            $0.hidesWhenStopped = true
            $0.color = .gray
        }
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        
        displayNavigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(42)
        }
        
        displayEditTextField.snp.makeConstraints {
            $0.height.equalTo(0)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
        
        displayView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(375)
            $0.center.equalToSuperview()
        }
        
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(displayView.snp.bottom).offset(36)
            $0.width.equalTo(200)
            $0.height.equalTo(60)
            $0.centerX.equalTo(displayView)
        }
        
        archiveButton.snp.makeConstraints {
            $0.left.equalTo(confirmButton.snp.right).offset(10)
            $0.centerY.equalTo(confirmButton)
        }
        
        displayIndicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        displayEditButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-15)
            $0.centerX.equalToSuperview()
        }
        
        displayEditCollectionView.snp.makeConstraints {
            $0.height.equalTo(61)
            $0.width.equalTo(view.frame.size.width - 43)
            $0.centerY.equalToSuperview().offset(-100)
            $0.centerX.equalToSuperview()
        }
        
    }
    
    
    public override func bind(reactor: CameraDisplayViewReactor) {
        archiveButton
            .rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .map { Reactor.Action.didTapArchiveButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        displayEditButton
            .rx.tap
            .withUnretained(self)
            .subscribe { owner, _ in
                owner.displayEditTextField.becomeFirstResponder()
            }.disposed(by: disposeBag)
        
        
        displayNavigationBar.rx.didTapLeftBarButton
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }.disposed(by: disposeBag)
        
        displayEditTextField.rx
            .text.orEmpty
            .distinctUntilChanged()
            .filter { $0.count <= 8 && !$0.contains(" ") }
            .observe(on: MainScheduler.instance)
            .map { Reactor.Action.fetchDisplayImage($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        displayEditTextField.rx
            .text.orEmpty
            .map { $0.contains(" ") }
            .distinctUntilChanged()
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { owner, isShow in
                guard isShow == true else { return }
                owner.makeRoundedToastView(title: "띄어쓰기는 할 수 없어요", designSystemImage: DesignSystemAsset.warning.image, width: 230, height: 56, offset: 400)
            }.disposed(by: disposeBag)
        
        displayEditTextField.rx
            .text.orEmpty
            .distinctUntilChanged()
            .map { ($0.count > 8) }
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { owner, isShow in
                guard isShow == true else { return }
                owner.makeRoundedToastView(title: "8자까지 입력가능해요", designSystemImage: DesignSystemAsset.warning.image, width: 211, height: 56, offset: 400)
            }.disposed(by: disposeBag)
        
        displayEditTextField.rx
            .text.orEmpty
            .scan("") { previous, new -> String in
                if new.count > 8 {
                  return previous
                } else {
                  return new
                }
            }.bind(to: displayEditTextField.rx.text)
            .disposed(by: disposeBag)
        
        
        confirmButton.rx
            .tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .map { Reactor.Action.didTapConfirmButton}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        reactor.state
            .map { $0.displayDescrption.count >= 1}
            .observe(on: MainScheduler.instance)
            .bind(to: displayEditButton.rx.isHidden)
            .disposed(by: disposeBag)
            
        
        displayEditCollectionView
            .rx.tap
            .observe(on: MainScheduler.instance)
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { $0.0.didTapCollectionViewTransition($0.0)})
            .disposed(by: disposeBag)
        
        displayDimView
            .rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind { owner, _ in
                owner.view.endEditing(true)
            }.disposed(by: disposeBag)
        
        
        NotificationCenter.default
            .rx.notification(UIResponder.keyboardWillShowNotification)
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { $0.0.keyboardWillShowGenerateUI($0.0)})
            .disposed(by: disposeBag)
        
        
        NotificationCenter.default
            .rx.notification(UIResponder.keyboardWillHideNotification)
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: {$0.0.keyboardWillHideGenerateUI($0.0)})
            .disposed(by: disposeBag)
        
        Observable
            .just(())
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$displayData)
            .map { UIImage(data: $0) }
            .asDriver(onErrorJustReturn: .none)
            .drive(displayView.rx.image)
            .disposed(by: disposeBag)
        
        
        reactor.state
            .map { $0.isLoading }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            .drive(displayIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$displayData)
            .skip(until: rx.methodInvoked(#selector(viewWillAppear(_:))))
            .withUnretained(self)
            .bind(onNext: { $0.0.setupCameraDisplayPermission(owner: $0.0, $0.1) })
            .disposed(by: disposeBag)
        
        displayEditCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$displaySection)
            .observe(on: MainScheduler.asyncInstance)
            .asDriver(onErrorJustReturn: [])
            .drive(displayEditCollectionView.rx.items(dataSource: displayEditDataSources))
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.displayPostEntity?.postId }
            .filter { !$0.isEmpty }
            .withUnretained(self)
            .bind(onNext: { $0.0.transitionToHomeViewController()})
            .disposed(by: disposeBag)
        
    }
}


extension CameraDisplayViewController {
    private func setupCameraDisplayPermission(owner: CameraDisplayViewController, _ originalData: Data) {
        let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
        if status == .authorized || status == .limited {
            PHPhotoLibrary.shared().performChanges {
                let creationRequest = PHAssetCreationRequest.forAsset()
                creationRequest.addResource(with: .photo, data: originalData, options: nil)
                owner.makeRoundedToastView(
                    title: "사진이 저장되었습니다.",
                    designSystemImage: DesignSystemAsset.camera.image.withTintColor(DesignSystemAsset.gray300.color),
                    height: 56
                )
            }
        } else {
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { stauts in
                switch status {
                case .denied:
                    DispatchQueue.main.async {
                        self.showPermissionAlertController()
                    }
                default:
                    print("다른 여부의 권한을 거부 당했습니다.")
                }
            }
        }
    }
    
    private func keyboardWillHideGenerateUI(_ owner: CameraDisplayViewController) {
        owner.displayEditTextField.snp.updateConstraints {
            $0.height.equalTo(0)
        }
        owner.dismissDimView()
        UIView.animate(withDuration: 0.5) {
            owner.displayEditCollectionView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7).translatedBy(x: 0, y: 300)
        }
        owner.displayEditTextField.isHidden = true
    }
    
    private func keyboardWillShowGenerateUI(_ owner: CameraDisplayViewController) {
        owner.displayEditTextField.isHidden = false
        owner.presentDimView()
        owner.displayView.bringSubviewToFront(owner.displayEditCollectionView)
        owner.displayDimView.backgroundColor = .black.withAlphaComponent(0.5)
        owner.displayEditTextField.snp.updateConstraints {
            $0.height.equalTo(46)
        }
    }
    
    private func didTapCollectionViewTransition(_ owner: CameraDisplayViewController) {
        owner.displayEditTextField.becomeFirstResponder()
        UIView.animate(withDuration: 0.5) {
            owner.displayEditCollectionView.transform = .identity
        }
    }
    
    private func presentDimView() {
        view.addSubview(displayDimView)
        displayDimView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        view.bringSubviewToFronts(displayEditCollectionView, displayEditTextField)
        displayDimView.backgroundColor = .black.withAlphaComponent(0.5)
    }
    
    private func dismissDimView() {
        view.subviews.forEach {
            if $0.backgroundColor == UIColor.black.withAlphaComponent(0.5) {
                $0.removeFromSuperview()
            }
        }
    }
    
    private func showPermissionAlertController() {
        let permissionAlertController: UIAlertController = UIAlertController(title: "앨범 접근 권한 설정이 없습니다.", message: "앨범에 저장하려면 앨범에 접근할 수 있도록 허용되어 있어야 합니다.", preferredStyle: .alert)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "취소", style: .cancel) { _ in
            permissionAlertController.dismiss(animated: true)
        }
        
        let settingAction: UIAlertAction = UIAlertAction(title: "설정으로 이동하기", style: .default) { _ in
            UIApplication.shared.open(URLTypes.settings.originURL)
        }
        
        [cancelAction,settingAction].forEach(permissionAlertController.addAction(_:))
        
        present(permissionAlertController, animated: true)
    }
    
    private func transitionToHomeViewController() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension CameraDisplayViewController: UICollectionViewDelegateFlowLayout {}

