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
    private let confirmButton: UIButton = UIButton()
    private let displayIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
    private let titleView: UILabel = UILabel()
    private let displayEditButton: UIButton = UIButton.createCircleButton(radius: 21.5)
    private let displayEditTextField: UITextField = UITextField()
    private let displayDimView: UIView = UIView()
    private let archiveButton: UIButton = UIButton.createCircleButton(radius: 24)
    private let displayEditCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let displayEditDataSources: RxCollectionViewSectionedReloadDataSource<DisplayEditSectionModel> = .init { dataSources, collectionView, indexPath, sectionItem in
        switch sectionItem {
        case let .fetchDisplayItem(cellReactor):
            guard let displayEditCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DisplayEditCollectionViewCell", for: indexPath) as? DisplayEditCollectionViewCell else { return UICollectionViewCell() }
            displayEditCell.reactor = cellReactor
            return displayEditCell
        }
    }
    
    //MARK: LifeCylce
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Configure
    public override func setupUI() {
        super.setupUI()
        view.addSubviews(displayView, confirmButton, archiveButton, displayIndicatorView, displayEditTextField, displayEditCollectionView)
        displayView.addSubviews(displayEditButton)
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        
        titleView.do {
            $0.textColor = .white
            $0.text = "사진 올리기"
        }
        
        navigationItem.do {
            $0.titleView = titleView
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
            $0.setTitle("T", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = .black.withAlphaComponent(0.3)
        }
        
        confirmButton.do {
            $0.backgroundColor = UIColor(red: 71/255, green: 234/255, blue: 166/255, alpha: 1.0)
            $0.isUserInteractionEnabled = true
            $0.setTitleColor(.black, for: .normal)
            $0.layer.cornerRadius = 30
            $0.clipsToBounds = true
            $0.setTitle("사진 업로드", for: .normal)
        }
        
        displayEditTextField.do {
            $0.textColor = .white
            $0.backgroundColor = UIColor(red: 53/255, green: 53/255, blue: 56/255, alpha: 1.0)
            $0.font = .systemFont(ofSize: 17, weight: .regular)
            $0.makeLeftPadding(16)
            $0.makeClearButton(DesignSystemAsset.clear.image)
            $0.makePlaceholderAttributedString("최대 8글자 이내로 입력해주세요.", attributed: [
                .font: UIFont.systemFont(ofSize: 17, weight: .regular),
                .foregroundColor: UIColor(red: 142/255, green: 142/255, blue: 142/255, alpha: 1.0)
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
        
        displayEditTextField.rx
            .text.orEmpty
            .distinctUntilChanged()
            .filter { $0.count <= 8 }
            .observe(on: MainScheduler.instance)
            .map { Reactor.Action.fetchDisplayImage($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        displayEditTextField.rx
            .text.orEmpty
            .distinctUntilChanged()
            .map { ($0.count > 8) }
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
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
            .asDriver(onErrorJustReturn: [])
            .drive(displayEditCollectionView.rx.items(dataSource: displayEditDataSources))
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
                owner.makeToastView(title: "이미지가 저장되었습니다.", textColor: .white, radius: 5)
            }
        } else {
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { stauts in
                switch status {
                case .authorized, .limited:
                    print("앨범 및 사진에 대한 권한이 부여 되었습니다.")
                case .denied:
                    //TODO: 권한 Alert 팝업 추가 예정
                    print("앨범 및 사진에 대한 권한을 거부 당했습니다.")
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
        view.bringSubviewToFront(displayEditCollectionView)
        displayDimView.backgroundColor = .black.withAlphaComponent(0.5)
    }
    
    private func dismissDimView() {
        view.subviews.forEach {
            if $0.backgroundColor == UIColor.black.withAlphaComponent(0.5) {
                $0.removeFromSuperview()
            }
        }
    }
}

extension CameraDisplayViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 38, height: 61)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
}
