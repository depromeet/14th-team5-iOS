//
//  FeedCollectionViewCell.swift
//  App
//
//  Created by 마경미 on 07.12.23.
//

import UIKit

import Core
import DesignSystem
import Domain

import RxDataSources
import RxSwift

final class FeedCollectionViewCell: BaseCollectionViewCell<SurvivalCellReactor> {
    typealias Layout = HomeAutoLayout.FeedCollectionView
    static let id = "FeedCollectionViewCell"
    
    private let stackView = UIStackView()
    private let nameLabel = BibbiLabel(.body2Regular, textAlignment: .left, textColor: .gray200)
    private let timeLabel = BibbiLabel(.caption, textAlignment: .right, textColor: .gray400)
    private let imageView = UIImageView(image: DesignSystemAsset.emptyCaseGraphicEmoji.image)
    
    override func bind(reactor: SurvivalCellReactor) {
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    override func setupUI() {
        addSubviews(imageView, stackView)
        stackView.addArrangedSubviews(nameLabel, timeLabel)
    }
    
    override func setupAutoLayout() {
        imageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(self.snp.width)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(Layout.StackView.horizontalInset)
            $0.height.equalTo(Layout.StackView.height)
        }
    }
    
    override func setupAttributes() {
        stackView.do {
            $0.distribution = .fillProportionally
            $0.spacing = Layout.StackView.spacing
        }
        
        imageView.do {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.layer.cornerRadius = Layout.ImageView.cornerRadius
        }
    }
}

extension FeedCollectionViewCell {
    private func bindInput(reactor: SurvivalCellReactor) {
        Observable.just(())
            .take(1)
            .map { Reactor.Action.setCell }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: SurvivalCellReactor) {
        reactor.state.map { $0.postListData }
            .distinctUntilChanged()
            .withUnretained(self)
            .bind(onNext: { $0.0.setCell($0.1)})
            .disposed(by: disposeBag)
    }
}

extension FeedCollectionViewCell {
    private func setCell(_ data: PostListData) {
        if let url = URL(string: data.imageURL ) {
            imageView.kf.setImage(with: url)
        } else {
            imageView.image = DesignSystemAsset.emptyCaseGraphicEmoji.image
        }
        
        nameLabel.text = data.author?.name ?? "알 수 없음"
        timeLabel.text = data.time.toDate(with: "yyyy-MM-dd'T'HH:mm:ssZ").relativeFormatter()
    }
    
    private func createContentDataSource() -> RxCollectionViewSectionedReloadDataSource<DisplayEditSectionModel> {
        return RxCollectionViewSectionedReloadDataSource<DisplayEditSectionModel> { datasources, collectionView, indexPath, sectionItem in
            switch sectionItem {
            case let .fetchDisplayItem(cellReactor):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DisplayEditCollectionViewCell.id, for: indexPath) as? DisplayEditCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.reactor = cellReactor
                return cell
            }
        }
    }
}

extension FeedCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let cellCount = reactor?.currentState.postListData.content?.count else {
            return .zero
        }
        
        let totalCellWidth = 17 * cellCount
        let totalSpacingWidth = 2 * (cellCount - 1)

        let leftInset = (collectionView.frame.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset

        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }
}
