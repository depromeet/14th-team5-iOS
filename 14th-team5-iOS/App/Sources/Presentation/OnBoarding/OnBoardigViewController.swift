//
//  OnBoardigViewController.swift
//  App
//
//  Created by geonhui Yu on 12/10/23.
//

import UIKit
import Core

import RxSwift
import RxCocoa
import ReactorKit
import RxDataSources
import Then
import SnapKit

// MARK: 임시데이터
enum OnBoardingMock {
    static var info: [OnBoardingInfo] = [
        OnBoardingInfo(title: "11111", image: UIImage()),
        OnBoardingInfo(title: "22222", image: UIImage()),
        OnBoardingInfo(title: "33333", image: UIImage()),
    ]
}

final class OnBoardigViewController: BaseViewController<OnBoardingReactor> {
    
    private let nextButton = UIButton()
    private let pageControl = UIPageControl()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let horizontalFlowLayout = UICollectionViewFlowLayout()
    
    private var currentPage: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .cyan
    }
    
    override func setupUI() {
        super.setupUI()
        
        view.addSubviews(nextButton, pageControl, collectionView)
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        
        pageControl.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(30)
        }

        collectionView.snp.makeConstraints {
            $0.bottom.equalTo(pageControl.snp.top).offset(-10)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(pageControl.snp.bottom)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(56)
        }
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        
        collectionView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.backgroundColor = .black
            $0.isPagingEnabled = true
            $0.collectionViewLayout = horizontalFlowLayout
            $0.showsHorizontalScrollIndicator = false
            $0.register(OnBoardingCollectionViewCell.self, forCellWithReuseIdentifier: OnBoardingCollectionViewCell.id)
        }
        
        horizontalFlowLayout.do {
            $0.scrollDirection = .horizontal
        }
        
        pageControl.do {
            $0.isUserInteractionEnabled = false
            $0.currentPage = 0
            $0.numberOfPages = 3
            $0.pageIndicatorTintColor = .blue
            $0.currentPageIndicatorTintColor = .red
        }
        
        nextButton.do {
            $0.setTitle("알림 허용하고 시작하기", for: .normal)
            $0.backgroundColor = .blue
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
            .bind(onNext: { $0.0.dismiss(animated: true) })
            .disposed(by: disposeBag)
    }
}

extension OnBoardigViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return OnBoardingMock.info.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnBoardingCollectionViewCell.id, for: indexPath) as? OnBoardingCollectionViewCell else { return UICollectionViewCell() }
        cell.setData(data: OnBoardingMock.info[indexPath.row])
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        let contentOffsetX = scrollView.contentOffset.x
        guard width > 0, contentOffsetX.isFinite, !contentOffsetX.isNaN else {
            return
        }
        
        pageControl.currentPage = Int(contentOffsetX / width)
    }
}

extension OnBoardigViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

