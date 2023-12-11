//
//  MainViewController.swift
//  App
//
//  Created by 마경미 on 05.12.23.
//

import UIKit
import Core

import RxDataSources
import RxCocoa
import RxSwift
import SnapKit
import Then

final class MainViewController: BaseViewController<MainViewReactor> {
    private let manageFamilyButton = UIBarButtonItem()
    private let calendarButton = UIBarButtonItem()
    private let familyCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let feedCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let camerButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit {
        print("deinit MainViewController")
    }
    
    override func bind(reactor: MainViewReactor) {
        familyCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        feedCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        feedCollectionView.rx.itemSelected
            .map { Reactor.Action.cellSelected($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.selectedIndexPath }
            .compactMap { $0 }
            .withUnretained(self)
            .subscribe(onNext: { _ in
                self.navigationController?.pushViewController(FeedDetailViewController(), animated: true)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.familySections }
            .asObservable()
            .bind(to: familyCollectionView.rx.items(dataSource: createFamilyDataSource()))
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.feedSections }
            .asObservable()
            .bind(to: feedCollectionView.rx.items(dataSource: createFeedDataSource()))
            .disposed(by: disposeBag)
        
        camerButton
            .rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { owner, _ in
                let cameraViewController = CameraDIContainer().makeViewController()
                owner.navigationController?.pushViewController(cameraViewController, animated: true)
            }.disposed(by: disposeBag)
    }
    
    override func setupUI() {
        super.setupUI()
        view.addSubviews(familyCollectionView, feedCollectionView, camerButton)
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        
        familyCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(30)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(89)
        }
        
        feedCollectionView.snp.makeConstraints {
            $0.top.equalTo(familyCollectionView.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        camerButton.snp.makeConstraints {
            $0.top.equalTo(feedCollectionView.snp.bottom).offset(12)
            $0.size.equalTo(72)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        navigationItem.do {
            $0.title = "로고"
            $0.leftBarButtonItem = manageFamilyButton
            $0.rightBarButtonItem = calendarButton
        }
        
        manageFamilyButton.do {
            $0.image = UIImage(named: "Profile")
            $0.target = self
        }
        
        calendarButton.do {
            $0.image = UIImage(named: "Calendar")
            $0.target = self
        }
        
        familyCollectionView.do {
            $0.register(FamilyCollectionViewCell.self, forCellWithReuseIdentifier: FamilyCollectionViewCell.id)
            $0.backgroundColor = .clear
        }
        
        feedCollectionView.do {
            $0.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: FeedCollectionViewCell.id)
            $0.register(FeedCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FeedCollectionReusableView.id)
            $0.backgroundColor = .clear
        }
        
        camerButton.do {
            $0.setImage(UIImage(named: "Shutter"), for: .normal)
        }
    }
}

extension MainViewController {
    private func createFamilyDataSource() -> RxCollectionViewSectionedReloadDataSource<SectionModel<String, ProfileData>> {
        return RxCollectionViewSectionedReloadDataSource<SectionModel<String, ProfileData>>(
            configureCell: { (_, collectionView, indexPath, item) in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FamilyCollectionViewCell.id, for: indexPath) as? FamilyCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.setCell(data: item)
                return cell
            })
    }
    
    private func createFeedDataSource() -> RxCollectionViewSectionedReloadDataSource<SectionModel<String, FeedData>> {
        return RxCollectionViewSectionedReloadDataSource<SectionModel<String, FeedData>>(
            configureCell: { (_, collectionView, indexPath, item) in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCollectionViewCell.id, for: indexPath) as? FeedCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.setCell(data: item)
                return cell
            },
            configureSupplementaryView: { (dataSource, collectionView, kind, indexPath) in
                guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FeedCollectionReusableView.id, for: indexPath) as? FeedCollectionReusableView else {
                    return UICollectionReusableView()
                }
                headerView.setHeader(title: "피드")
                return headerView
            }
        )
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == familyCollectionView {
            return CGSize(width: 68, height: 89)
        } else {
            return CGSize(width: 160, height: 184)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == familyCollectionView {
            return UIEdgeInsets(top: 0, left: 26, bottom: 0, right: 26)
        } else {
            return UIEdgeInsets.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == familyCollectionView {
            return 17
        } else {
            return 20
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == feedCollectionView {
            return CGSize(width: collectionView.bounds.width, height: 44)
        }
        return CGSize.zero
    }
}

