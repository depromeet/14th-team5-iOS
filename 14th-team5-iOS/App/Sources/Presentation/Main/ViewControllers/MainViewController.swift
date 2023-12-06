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

// 섹션데이터
struct SectionOfFamily {
    var items: [ProfileData]
    
    init(items: [ProfileData]) {
        self.items = items
    }
}

// 섹션 데이터: SectionModelType
extension SectionOfFamily: SectionModelType {
    typealias Item = ProfileData
    
    init(original: SectionOfFamily, items: [ProfileData]) {
        self = original
        self.items = items
    }
}

class MainViewController: BaseViewController<MainViewReactor> {
    typealias SectionOfFamily = SectionModel<String, ProfileData>
    
    private let collectionView = UICollectionView()
    
    private let sections = [
        SectionOfFamily(model: "section1", items: [
            ProfileData(imageURL: "https://wimg.mk.co.kr/news/cms/202304/14/news-p.v1.20230414.15e6ac6d76a84ab398281046dc858116_P1.jpg", name: "Jenny"),
            ProfileData(imageURL: "https://wimg.mk.co.kr/news/cms/202304/14/news-p.v1.20230414.15e6ac6d76a84ab398281046dc858116_P1.jpg", name: "Jenny"),
            ProfileData(imageURL: "https://wimg.mk.co.kr/news/cms/202304/14/news-p.v1.20230414.15e6ac6d76a84ab398281046dc858116_P1.jpg", name: "Jenny"),
            ProfileData(imageURL: "https://wimg.mk.co.kr/news/cms/202304/14/news-p.v1.20230414.15e6ac6d76a84ab398281046dc858116_P1.jpg", name: "Jenny"),
          ])
      ]
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    public override func bind(reactor: MainViewReactor) {
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfFamily>(
            configureCell: { (_, collectionView, indexPath, item) in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FamilyCollectionViewCell.id, for: indexPath) as? FamilyCollectionViewCell else {
                    return UICollectionViewCell()
                }
                return cell
            })
        
        Observable.just(sections)
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }

    public override func setupUI() {
        collectionView.do {
            $0.backgroundColor = .clear
        }
    }
    
    public override func setupAutoLayout() { }
    
    public override func setupAttributes() {
        super.setupAttributes()
        
    }
}

