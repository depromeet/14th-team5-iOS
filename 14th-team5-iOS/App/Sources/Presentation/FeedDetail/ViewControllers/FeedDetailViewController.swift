//
//  FeedDetailViewController.swift
//  App
//
//  Created by 마경미 on 09.12.23.
//

import UIKit
import Core

import RxDataSources
import RxSwift

final class FeedDetailViewController: BaseViewController<FeedDetailReactor> {
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let layout = UICollectionViewFlowLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bind(reactor: FeedDetailReactor) {
        Observable.just(SectionOfFeedDetail.sections)
            .bind(to: collectionView.rx.items(dataSource: createDataSource()))
            .disposed(by: disposeBag)
    }
    
    override func setupUI() {
        super.setupUI()
        view.addSubview(collectionView)
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        
        layout.do {
            $0.sectionInset = .zero
            $0.scrollDirection = .horizontal
            $0.minimumLineSpacing = 0
        }
        
        collectionView.do {
            $0.delegate = self
            $0.isPagingEnabled = true
            $0.backgroundColor = .clear
            $0.register(FeedDetailCollectionViewCell.self, forCellWithReuseIdentifier: FeedDetailCollectionViewCell.id)
            $0.collectionViewLayout = layout
        }
    }
}

extension FeedDetailViewController {
    private func createDataSource() -> RxCollectionViewSectionedReloadDataSource<SectionModel<String, FeedDetailData>> {
        return RxCollectionViewSectionedReloadDataSource<SectionModel<String, FeedDetailData>>(
            configureCell: { dataSource, collectionView, indexPath, item in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedDetailCollectionViewCell.id, for: indexPath) as? FeedDetailCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.setCell(data: item)
                return cell
            })
    }
}

extension FeedDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
