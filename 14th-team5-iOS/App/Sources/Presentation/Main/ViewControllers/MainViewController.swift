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
    private let familyCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let feedCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let camerButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind(reactor: MainViewReactor())
    }
    
    deinit {
        print("deinit MainViewController")
    }
    
    override func bind(reactor: MainViewReactor) {
        familyCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        feedCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, ProfileData>>(
            configureCell: { (_, collectionView, indexPath, item) in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FamilyCollectionViewCell.id, for: indexPath) as? FamilyCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.setCell(data: item)
                return cell
            })
        
        Observable.just(SectionOfFamily.sections)
            .bind(to: familyCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        let dataSource2 = RxCollectionViewSectionedReloadDataSource<SectionModel<String, FeedData>>(
            configureCell: { (_, collectionView, indexPath, item) in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCollectionViewCell.id, for: indexPath) as? FeedCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.setCell(data: item)
                return cell
            })
        
        Observable.just(SectionOfFeed.sections)
            .bind(to: feedCollectionView.rx.items(dataSource: dataSource2))
            .disposed(by: disposeBag)
    }
    
    override func setupUI() {
        familyCollectionView.do {
            $0.register(FamilyCollectionViewCell.self, forCellWithReuseIdentifier: FamilyCollectionViewCell.id)
            $0.backgroundColor = .clear
        }
        
        feedCollectionView.do {
            $0.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: FeedCollectionViewCell.id)
            $0.backgroundColor = .clear
        }
        
        camerButton.do {
            $0.setImage(UIImage(named: "Shutter"), for: .normal)
        }
    }
    
    override func setupAutoLayout() {
        view.addSubviews(familyCollectionView, feedCollectionView, camerButton)
        
        familyCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == familyCollectionView {
            return 17
        } else {
            return 20
        }
    }
}

