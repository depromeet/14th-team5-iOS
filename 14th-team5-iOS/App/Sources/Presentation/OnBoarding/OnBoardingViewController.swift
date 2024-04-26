//
//  OnBoardingViewController.swift
//  App
//
//  Created by geonhui Yu on 12/10/23.
//

import UIKit
import Core
import DesignSystem

import RxSwift
import RxCocoa
import ReactorKit
import RxDataSources
import Then
import SnapKit

final public class OnBoardingViewController: BaseViewController<OnBoardingReactor> {
    private let nextButton = UIButton()
    private let pageControl = UIPageControl()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let horizontalFlowLayout = UICollectionViewFlowLayout()
    
    private var currentPage = PublishRelay<Int>()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = DesignSystemAsset.mainYellow.color
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    public override func setupUI() {
        super.setupUI()
        
        view.addSubviews(nextButton, pageControl, collectionView)
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        
        collectionView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        pageControl.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(55)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(8)
        }
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(pageControl.snp.bottom).offset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.height.equalTo(56)
        }
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        
        collectionView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.isPagingEnabled = true
            $0.contentInset = .zero
            $0.collectionViewLayout = horizontalFlowLayout
            $0.backgroundColor = DesignSystemAsset.mainYellow.color
            $0.showsHorizontalScrollIndicator = false
            $0.register(OnBoardingCollectionViewCell.self,
                        forCellWithReuseIdentifier: OnBoardingCollectionViewCell.id)
        }
        
        horizontalFlowLayout.do {
            $0.sectionInset = .zero
            $0.scrollDirection = .horizontal
        }
        
        pageControl.do {
            $0.isUserInteractionEnabled = false
            $0.currentPage = 0
            $0.numberOfPages = 4
            $0.pageIndicatorTintColor = DesignSystemAsset.black.color.withAlphaComponent(0.2)
            $0.currentPageIndicatorTintColor = DesignSystemAsset.black.color
        }
        
        nextButton.do {
            $0.setTitle(OnBoardingStrings.normalButtonTitle, for: .normal)
            $0.setTitleColor(DesignSystemAsset.white.color, for: .normal)
            $0.titleLabel?.font = UIFont(font: DesignSystemFontFamily.Pretendard.bold, size: 16)
            $0.backgroundColor = DesignSystemAsset.black.color.withAlphaComponent(0.2)
            $0.layer.cornerRadius = 28
            $0.isEnabled = false
        }
        
        if UserDefaults.standard.inviteCode?.isEmpty == false {
            nextButton.setTitle(OnBoardingStrings.inviteButtonTitle, for: .normal)
        }
    }
    
    public override func bind(reactor: OnBoardingReactor) {
        super.bind(reactor: reactor)
        
        currentPage
            .distinctUntilChanged()
            .withUnretained(self)
            .observe(on: Schedulers.main)
            .bind(onNext: {
                $0.0.validationButtion(for: $0.1)
                $0.0.pageControl.currentPage = $0.1
            })
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .throttle(RxConst.throttleInterval, scheduler: Schedulers.main)
            .map { Reactor.Action.permissionTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.permissionTappedFinish }
            .distinctUntilChanged()
            .observe(on: Schedulers.main)
            .withUnretained(self)
            .bind(onNext: {
                UserDefaults.standard.finishTutorial = $0.1
                $0.0.showNextPage($0.1)
            })
            .disposed(by: disposeBag)
    }
    
    private func validationButtion(for index: Int) {
        let defaultColor = DesignSystemAsset.black.color
        nextButton.backgroundColor = index == 3 ? defaultColor : defaultColor.withAlphaComponent(0.2)
        nextButton.isEnabled = index == 3
    }
    
    private func showNextPage(_ show: Bool) {
        guard show else { return }
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
        
        if App.Repository.member.familyId.value == nil {
            sceneDelegate.window?.rootViewController = UINavigationController(rootViewController: JoinFamilyDIContainer().makeViewController())
            sceneDelegate.window?.makeKeyAndVisible()
        } else {
            if let _ = UserDefaults.standard.inviteCode {
                sceneDelegate.window?.rootViewController = UINavigationController(rootViewController: JoinedFamilyDIContainer().makeViewController())
            } else {
                sceneDelegate.window?.rootViewController = UINavigationController(rootViewController: MainViewDIContainer().makeViewController())
            }
            
            sceneDelegate.window?.makeKeyAndVisible()
        }
    }
}

extension OnBoardingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return OnBoarding.info.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnBoardingCollectionViewCell.id, for: indexPath) as? OnBoardingCollectionViewCell else { return UICollectionViewCell() }
        cell.setData(data: OnBoarding.info[indexPath.row])
        return cell
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        let contentOffsetX = scrollView.contentOffset.x
        guard width > 0, contentOffsetX.isFinite, !contentOffsetX.isNaN else {
            return
        }
        
        currentPage.accept(Int(contentOffsetX / width))
    }
}

extension OnBoardingViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

