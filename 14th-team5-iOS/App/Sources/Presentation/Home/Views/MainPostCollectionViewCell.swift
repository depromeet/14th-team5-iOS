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

final class MainPostCollectionViewCell: BaseCollectionViewCell<MainPostCellReactor> {
    typealias Layout = HomeAutoLayout.FeedCollectionView
    static let id = "FeedCollectionViewCell"
    
    private let imageView: UIImageView = UIImageView(image: DesignSystemAsset.emptyCaseGraphicEmoji.image)
    private let indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
    private let missionBadge: UIImageView = UIImageView(image: DesignSystemAsset.mission.image)
    private let stackView: UIStackView = UIStackView()
    private let nameLabel: BibbiLabel = BibbiLabel(.body2Regular, textAlignment: .left, textColor: .gray200)
    private let timeLabel: BibbiLabel = BibbiLabel(.caption, textAlignment: .right, textColor: .gray400)

    override func bind(reactor: MainPostCellReactor) {
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    override func setupUI() {
        addSubviews(imageView, missionBadge, stackView)
        stackView.addArrangedSubviews(nameLabel, timeLabel)
    }
    
    override func setupAutoLayout() {
        imageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(self.snp.width)
        }
        
        missionBadge.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(12)
            $0.size.equalTo(24)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(Layout.StackView.horizontalInset)
            $0.height.equalTo(Layout.StackView.height)
        }
    }
    
    override func setupAttributes() {
        indicator.startAnimating()
        
        imageView.do {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.layer.cornerRadius = Layout.ImageView.cornerRadius
        }
        
        missionBadge.do {
            $0.isHidden = true
        }
        
        stackView.do {
            $0.distribution = .fillProportionally
            $0.spacing = Layout.StackView.spacing
        }
    }
}

extension MainPostCollectionViewCell {
    private func bindInput(reactor: MainPostCellReactor) {
        Observable.just(())
            .take(1)
            .map { Reactor.Action.setCell }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: MainPostCellReactor) {
        reactor.state.map { $0.postListData }
            .distinctUntilChanged()
            .withUnretained(self)
            .bind(onNext: { $0.0.setCell($0.1)})
            .disposed(by: disposeBag)
    }
}

extension MainPostCollectionViewCell {
    private func setCell(_ data: PostListData) {
        if let url = URL(string: data.imageURL ) {
            imageView.kf.setImage(with: url)
            indicator.stopAnimating()
        } else {
            imageView.image = DesignSystemAsset.emptyCaseGraphicEmoji.image
        }
        
        missionBadge.isHidden = data.missionId == nil ? true : false
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

extension MainPostCollectionViewCell: UICollectionViewDelegateFlowLayout {
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
