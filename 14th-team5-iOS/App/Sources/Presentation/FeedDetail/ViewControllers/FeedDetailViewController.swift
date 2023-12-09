//
//  FeedDetailViewController.swift
//  App
//
//  Created by 마경미 on 09.12.23.
//

import UIKit
import Core

final class FeedDetailViewController: BaseViewController<FeedDetailReactor> {
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func bind(reactor: FeedDetailReactor) {
//        <#code#>
    }
    
    override func setupUI() {
        super.setupUI()
        view.addSubview(collectionView)
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        collectionView.do {
            $0.backgroundColor = .clear
            $0.setCollectionViewLayout(createLayout(), animated: true)
        }
    }
}

extension FeedDetailViewController {
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            if sectionIndex == 0 {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalHeight(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)

                let section = NSCollectionLayoutSection(group: group)
//                section.orthogonalScrollingBehavior = .continuous

                return section
            } else {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 8)

                let section = NSCollectionLayoutSection(group: group)
//                section.orthogonalScrollingBehavior = .continuous
                return section
            }
        }

    }
}
