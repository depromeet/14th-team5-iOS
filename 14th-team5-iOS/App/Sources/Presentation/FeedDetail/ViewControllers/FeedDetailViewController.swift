//
//  PostViewController.swift
//  App
//
//  Created by 마경미 on 09.12.23.
//

import UIKit
import Core
import Domain

import RxDataSources
import RxSwift

// index 조회 필요 => index 조회 이후 스크롤시 이전/이후 포스트 조회 할 수 있어야함
final class PostViewController: BaseViewController<PostReactor> {
    private let backgroundImageView: UIImageView = UIImageView()
    private let blurEffectView: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.dark))
    private let navigationView: PostNavigationView = PostNavigationView()
    private let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func bind(reactor: PostReactor) {
        reactor.state
            .map { $0.originPostLists }
            .asObservable()
            .bind(to: collectionView.rx.items(dataSource: createDataSource()))
            .disposed(by: disposeBag)
        
//        collectionView.rx.didScroll
//            .map { Reactor.Action.fetchPost("01HJBRBSZRF429S1SES900ET5G") }
//            .bind(to: reactor.action)
//            .disposed(by: disposeBag)
    }
    
    override func setupUI() {
        super.setupUI()
        
        view.addSubviews(backgroundImageView, blurEffectView, navigationView,
                         collectionView)
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        blurEffectView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        navigationView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(52)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        
        backgroundImageView.do {
            $0.kf.setImage(with: URL(string: "https://src.hidoc.co.kr/image/lib/2021/4/28/1619598179113_0.jpg")!)
        }
        
        blurEffectView.do {
            $0.frame = backgroundImageView.bounds
            $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
        
        layout.do {
            $0.sectionInset = .zero
            $0.scrollDirection = .horizontal
            $0.minimumLineSpacing = 0
        }
        
        collectionView.do {
            $0.delegate = self
            $0.isPagingEnabled = true
            $0.backgroundColor = .clear
            $0.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCollectionViewCell.id)
            $0.collectionViewLayout = layout
            $0.contentInsetAdjustmentBehavior = .never
            $0.scrollIndicatorInsets = .zero
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
        }
    }
}

extension PostViewController {
    private func createDataSource() -> RxCollectionViewSectionedReloadDataSource<SectionModel<String, PostListData>> {
        return RxCollectionViewSectionedReloadDataSource<SectionModel<String, PostListData>>(
            configureCell: { dataSource, collectionView, indexPath, item in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.id, for: indexPath) as? PostCollectionViewCell else {
                    return UICollectionViewCell()
                }
//                cell.reactor = self.reactor
                // 여기가 아니라 didScroll => 로 옮겨야햇
                cell.setCell(data: item)
                self.setNavigationView(data: item)
                self.setBackgroundView(data: item)
                return cell
            })
    }
    
    // cell.setCell과 setData => reactorkit으로 옮기기
    private func setNavigationView(data: PostListData) {
        self.navigationView.setData(data: data)
    }
    
    private func setBackgroundView(data: PostListData) {
        guard let url = URL(string: data.imageURL) else {
            return
        }
        self.backgroundImageView.kf.setImage(with: url)
    }
}

extension PostViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
