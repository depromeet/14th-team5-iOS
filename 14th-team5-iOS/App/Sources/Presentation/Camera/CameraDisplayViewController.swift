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
    private let missionDisplayView: BibbiMissionView = BibbiMissionView()
    private let confirmButton: UIButton = UIButton(configuration: .plain())
    private let displayIndicatorView: BibbiLoadingView = BibbiLoadingView()
    private let backButton: UIButton = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 52, height: 52)))
    private let titleView: BBLabel = BBLabel(.head2Bold, textColor: .gray200)
    private let displayEditButton: UIButton = UIButton()
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
        BBLogManager.analytics(logType: BBEventAnalyticsLog.viewPage(pageName: .cameraDetail))
    }
    
    //MARK: Configure
    public override func setupUI() {
        super.setupUI()
        view.addSubviews(displayView, missionDisplayView, confirmButton, archiveButton, displayEditTextField, displayEditCollectionView, displayIndicatorView)
        displayView.addSubviews(displayEditButton)
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        
        displayEditCollectionViewLayout.do {
            $0.itemSize = CGSize(width: 38, height: 61)
            $0.minimumInteritemSpacing = 4
        }
        
        navigationBarView.do {
            $0.setNavigationView(leftItem: .arrowLeft, centerItem: .label("사진 올리기"), rightItem: .empty)
        }
        
        archiveButton.do {
            $0.setImage(DesignSystemAsset.archive.image, for: .normal)
            $0.backgroundColor = .darkGray
        }
        
        displayView.do {
            $0.layer.cornerRadius = 40
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
            $0.isUserInteractionEnabled = true
        }
        
        displayEditButton.do {
            let blurEffectView = UIVisualEffectView.makeBlurView(style: .systemUltraThinMaterialDark)
            blurEffectView.frame = $0.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurEffectView.isUserInteractionEnabled = false
            $0.insertSubview(blurEffectView, at: 0)
            $0.configuration = .plain()
            $0.configuration?.attributedTitle = AttributedString(NSAttributedString(string: "텍스트 입력하기", attributes: [
                .foregroundColor: DesignSystemAsset.white.color,
                .font: DesignSystemFontFamily.Pretendard.semiBold.font(size: 18),
                .kern: -0.3,

            ]))
            $0.configuration?.imagePlacement = .leading
            $0.configuration?.imagePadding = 5
            $0.configuration?.image = DesignSystemAsset.edit.image
            $0.layer.cornerRadius = 10
            $0.clipsToBounds = true
        }
        
        confirmButton.do {
            $0.backgroundColor = DesignSystemAsset.mainYellow.color
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
            $0.makePlaceholderAttributedString("여덟자로입력해요", attributed: [
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
        
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        
        missionDisplayView.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom).offset(26)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(46)
        }
        
        displayEditTextField.snp.makeConstraints {
            $0.height.equalTo(0)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
        
        displayView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(displayView.snp.width).multipliedBy(1.0)
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
            $0.width.equalTo(166)
            $0.height.equalTo(41)
        }
        
        displayEditCollectionView.snp.makeConstraints {
            $0.height.equalTo(61)
            $0.width.equalTo(view.frame.size.width - 43)
            $0.centerY.equalToSuperview().offset(-100)
            $0.centerX.equalToSuperview()
        }
        
    }
    
    
    public override func bind(reactor: CameraDisplayViewReactor) {
        super.bind(reactor: reactor)
        
        archiveButton
            .rx.tap
            .throttle(RxInterval._600milliseconds, scheduler: RxScheduler.main)
            .map { Reactor.Action.didTapArchiveButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        displayEditButton
            .rx.tap
            .withUnretained(self)
            .subscribe { owner, _ in
                MPEvent.Camera.photoText.track(with: nil)
                owner.displayEditTextField.becomeFirstResponder()
            }
            .disposed(by: disposeBag)
  
        
        displayEditTextField
            .rx.text.changed
            .filter { $0?.isEmpty ?? false }
            .map { _ in Reactor.Action.fetchDisplayImage("여덟자로입력해요")}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.cameraType == .mission ? false : true }
            .bind(to: missionDisplayView.rx.isHidden)
            .disposed(by: disposeBag)
            
        
        reactor.pulse(\.$missionTitle)
            .bind(to: missionDisplayView.missionTitleView.rx.text)
            .disposed(by: disposeBag)
        
        displayEditTextField.rx
            .text.orEmpty
            .filter { !$0.isEmpty }
            .filter { $0.count <= 8 && !$0.contains(" ") }
            .observe(on: MainScheduler.instance)
            .distinctUntilChanged()
            .map { Reactor.Action.fetchDisplayImage($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        displayEditTextField.rx
            .text.orEmpty
            .filter { $0.contains(" ")}
            .map { Reactor.Action.showInputBlankTextError($0)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$displayText)
            .bind(to: displayEditTextField.rx.text)
            .disposed(by: disposeBag)
        
        displayEditTextField.rx
            .text.changed
            .compactMap { $0 }
            .filter { $0.contains(" ") || $0.count > 8 }
            .distinctUntilChanged()
            .debounce(RxInterval._600milliseconds, scheduler: RxScheduler.main)
            .map { _ in Reactor.Action.showInputTextError }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.pulse(\.$isError)
            .filter { $0 }
            .withUnretained(self)
            .bind(onNext: { $0.0.makeActionBibbiToastView(text: "사진 업로드 실패", transtionText: "홈으로 이동", duration: 1, offset: 50, direction: .up)})
            .disposed(by: disposeBag)
        
        displayEditTextField.rx
            .text.orEmpty
            .filter { !$0.contains(" ")}
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
            .throttle(RxInterval._600milliseconds, scheduler: RxScheduler.main)
            .map { Reactor.Action.didTapConfirmButton}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.displayDescrption.count >= 1}
            .observe(on: MainScheduler.instance)
            .bind(to: displayEditButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        displayEditButton
            .rx.tap
            .throttle(RxInterval._600milliseconds, scheduler: RxScheduler.main)
            .withLatestFrom(reactor.state.map{ $0.displayDescrption })
            .filter { $0.isValidation() }
            .withUnretained(self)
            .bind(onNext: { $0.0.didTapCollectionViewTransition()})
            .disposed(by: disposeBag)
            
        
        displayEditCollectionView
            .rx.tap
            .observe(on: MainScheduler.instance)
            .throttle(RxInterval._300milliseconds, scheduler: RxScheduler.main)
            .withUnretained(self)
            .bind(onNext: { $0.0.didTapCollectionViewTransition()})
            .disposed(by: disposeBag)
        
        displayDimView
            .rx.tap
            .throttle(RxInterval._300milliseconds, scheduler: RxScheduler.main)
            .withUnretained(self)
            .bind { owner, _ in
                owner.view.endEditing(true)
            }.disposed(by: disposeBag)
        
        
        displayEditTextField
            .rx.controlEvent(.editingDidEnd)
            .withLatestFrom(reactor.state.map { $0.displayDescrption })
            .filter { $0 == "여덟자로입력해요" }
            .observe(on: MainScheduler.instance)
            .map { _ in Reactor.Action.hideDisplayEditCell}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        NotificationCenter.default
            .rx.notification(UIResponder.keyboardWillShowNotification)
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { $0.0.keyboardWillShowGenerateUI()})
            .disposed(by: disposeBag)
        
        
        NotificationCenter.default
            .rx.notification(UIResponder.keyboardWillHideNotification)
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: {$0.0.keyboardWillHideGenerateUI()})
            .disposed(by: disposeBag)
        
        NotificationCenter.default
            .rx.notification(.didTapBibbiToastTranstionButton)
            .withUnretained(self)
            .bind { owner, _ in
                owner.navigationController?.popToRootViewController(animated: true)
            }.disposed(by: disposeBag)
        
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
            .map { $0.isError }
            .filter { $0 }
            .map { !$0 }
            .bind(to: confirmButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        
        reactor.state
            .map { $0.isLoading }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            .drive(displayIndicatorView.rx.isHidden)
            .disposed(by: disposeBag)
        
        displayEditCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$displaySection)
            .observe(on: MainScheduler.asyncInstance)
            .asDriver(onErrorJustReturn: [])
            .drive(displayEditCollectionView.rx.items(dataSource: displayEditDataSources))
            .disposed(by: disposeBag)
    }
}


extension CameraDisplayViewController {
    private func setupCameraDisplayPermission(_ originalData: Data) {
        let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
        if status == .authorized || status == .limited {
            PHPhotoLibrary.shared().performChanges { [weak self] in
                guard let `self` = self else { return }
                let creationRequest = PHAssetCreationRequest.forAsset()
                creationRequest.addResource(with: .photo, data: originalData, options: nil)
            }
        } else {
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { stauts in
                switch status {
                case .denied:
                    DispatchQueue.main.async { [weak self] in
                        guard let `self` = self else { return }
                        self.showPermissionAlertController()
                    }
                default:
                    print("다른 여부의 권한을 거부 당했습니다.")
                }
            }
        }
    }
    
    private func keyboardWillHideGenerateUI() {
        displayEditTextField.snp.updateConstraints {
            $0.height.equalTo(0)
        }
        dismissDimView()
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let `self` = self else { return }
            self.displayEditCollectionView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7).translatedBy(x: 0, y: self.displayEditButton.frame.midY)
        }
        displayEditTextField.isHidden = true
    }
    
    private func keyboardWillShowGenerateUI() {
        displayEditTextField.isHidden = false
        presentDimView()
        displayView.bringSubviewToFront(displayEditCollectionView)
        displayDimView.backgroundColor = .black.withAlphaComponent(0.5)
        displayEditTextField.snp.updateConstraints {
            $0.height.equalTo(46)
        }
    }
    
    private func didTapCollectionViewTransition() {
        displayEditTextField.becomeFirstResponder()
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let `self` = self else { return }
            self.displayEditCollectionView.transform = .identity
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
        permissionAlertController.overrideUserInterfaceStyle = .dark
        present(permissionAlertController, animated: true)
    }
    
}

extension CameraDisplayViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let displayCellCount = self.reactor?.currentState.displayDescrption.count else {
            return .zero
        }
        let displayCellWidth = 38 * displayCellCount
        let displayCellSpacingWidth = 4 * (displayCellCount - 1)
        let displayCellInset = (collectionView.frame.size.width - CGFloat(displayCellWidth + displayCellSpacingWidth)) / 2

        return UIEdgeInsets(top: 0, left: displayCellInset, bottom: 0, right: displayCellInset)
    }
    
}

