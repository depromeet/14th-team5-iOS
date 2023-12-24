//
//  OnBoardigViewController.swift
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

final class OnBoardigViewController: BaseViewController<OnBoardingReactor> {
    private let nextButton = UIButton()
    private let pageControl = UIPageControl()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let horizontalFlowLayout = UICollectionViewFlowLayout()
    
    private var currentPage: Int = 0 {
        didSet {
            self.pageControl.currentPage = currentPage
            self.nextButton.isEnabled = currentPage == 2
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        super.setupUI()
        
        view.addSubviews(nextButton, pageControl, collectionView)
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(30)
        }

        collectionView.snp.makeConstraints {
            $0.bottom.equalTo(pageControl.snp.top).inset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(pageControl.snp.bottom)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.height.equalTo(56)
        }
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        
        collectionView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.isPagingEnabled = true
            $0.contentInset = .zero
            $0.collectionViewLayout = horizontalFlowLayout
            $0.backgroundColor = DesignSystemAsset.black.color
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
            $0.numberOfPages = 3
            $0.pageIndicatorTintColor = .black.withAlphaComponent(0.2)
            $0.currentPageIndicatorTintColor = .white
        }
        
        nextButton.do {
            $0.setTitle(OnBoardingStrings.buttonTitle, for: .normal)
            $0.setTitleColor(DesignSystemAsset.black.color, for: .normal)
            $0.titleLabel?.font = UIFont(font: DesignSystemFontFamily.Pretendard.bold, size: 16)
            $0.backgroundColor = DesignSystemAsset.mainGreen.color
            $0.layer.cornerRadius = 24
        }
    }
    
    override func bind(reactor: OnBoardingReactor) {
        super.bind(reactor: reactor)
        
        nextButton.rx.tap
            .throttle(RxConst.throttleInterval, scheduler: Schedulers.main)
            .map { Reactor.Action.permissionTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isPermissionGranted ?? false }
            .observe(on: Schedulers.main)
            .withUnretained(self)
            .bind(onNext: { _ in print("개발끝") })
            .disposed(by: disposeBag)
    }
}

extension OnBoardigViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return OnBoarding.info.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnBoardingCollectionViewCell.id, for: indexPath) as? OnBoardingCollectionViewCell else { return UICollectionViewCell() }
        cell.setData(data: OnBoarding.info[indexPath.row])
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        let contentOffsetX = scrollView.contentOffset.x
        guard width > 0, contentOffsetX.isFinite, !contentOffsetX.isNaN else {
            return
        }
        
        self.currentPage = Int(contentOffsetX / width)
    }
}

extension OnBoardigViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

