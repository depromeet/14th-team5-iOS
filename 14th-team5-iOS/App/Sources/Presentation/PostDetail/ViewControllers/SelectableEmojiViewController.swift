//
//  EmojiSheetViewController.swift
//  App
//
//  Created by 마경미 on 26.01.24.
//

import UIKit

import Core
import DesignSystem

import RxSwift
import RxDataSources

final class SelectableEmojiViewController: BaseViewController<SelectableEmojiReactor>, UICollectionViewDelegate {
    let selectedReactionSubject: PublishSubject<Void>
    
    private let collectionViewLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private let selectableEmojiCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    private let cameraButton: UIButton = UIButton()
    
    init(selectedReactionSubject: PublishSubject<Void>) {
        self.selectedReactionSubject = selectedReactionSubject
        super.init()
    }
    
    convenience init(reactor: SelectableEmojiReactor, selectedReactionSubject: PublishSubject<Void>) {
        self.init(selectedReactionSubject: selectedReactionSubject)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind(reactor: SelectableEmojiReactor) {
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    override func setupUI() {
        super.setupUI()
        
        view.addSubviews(selectableEmojiCollectionView, cameraButton)
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        
        selectableEmojiCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(40)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        
        view.backgroundColor = .gray700
        
        collectionViewLayout.do {
            $0.minimumInteritemSpacing = 12
        }
        
        selectableEmojiCollectionView.do {
            $0.collectionViewLayout = collectionViewLayout
            $0.register(SelectableEmojiCollectionViewCell.self, forCellWithReuseIdentifier: SelectableEmojiCollectionViewCell.id)
            $0.backgroundColor = .clear
            $0.isScrollEnabled = false
        }
        
        cameraButton.do {
            $0.contentMode = .scaleToFill
            $0.setImage(DesignSystemAsset.cameraCircle.image, for: .normal)
        }
    }
    
    override func viewDidLayoutSubviews() {
        cameraButton.snp.makeConstraints {
            let trailingInsets: CGFloat = (selectableEmojiCollectionView.frame.width - (44 * 6) - (12 * 5)) / 2
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(40 + 44 + 24)
            $0.size.equalTo(44)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(trailingInsets)
        }
    }
}

extension SelectableEmojiViewController {
    private func bindInput(reactor: SelectableEmojiReactor) {
        selectableEmojiCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        self.rx.viewWillAppear
            .map { _ in Reactor.Action.loadMyRealEmoji }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        Observable.zip(selectableEmojiCollectionView.rx.itemSelected,
                       selectableEmojiCollectionView.rx.modelSelected(SelectableReactionSection.Item.self))
        .throttle(RxConst.milliseconds300Interval, scheduler: MainScheduler.instance)
        .map { (indexPath, selectedItem) in
            switch selectedItem {
            case .standard(let emojiData):
                return Reactor.Action.selectStandard(emojiData)
            case .realEmoji(let realEmojiData):
                return Reactor.Action.selectRealEmoji(indexPath, realEmojiData)
            }
        }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        cameraButton.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind(onNext: { owner, _ in
                owner.dismiss(animated: true) {
                    let userInfo: [AnyHashable: Any] = ["type": Emojis.emoji(forIndex: 1)]
                    NotificationCenter.default.post(name: .didTapSelectableCameraButton, object: nil, userInfo: userInfo)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: SelectableEmojiReactor) {
        reactor.state
            .map { $0.reactionSections }
            .distinctUntilChanged()
            .bind(to: selectableEmojiCollectionView.rx.items(dataSource: createDataSource()))
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.selectedRealEmoji }
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind(onNext: {
                $0.0.selectedReactionSubject.onNext(())
                $0.0.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
      
        reactor.state.map { $0.selectedStandard }
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind(onNext: {
                $0.0.selectedReactionSubject.onNext(())
                $0.0.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isShowingCamera)
            .skip(1)
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind(onNext: { owner, index in
                owner.dismiss(animated: true) {
                    let userInfo: [AnyHashable: Any] = ["type": Emojis.emoji(forIndex: index + 1)]
                    NotificationCenter.default.post(name: .didTapSelectableCameraButton, object: nil, userInfo: userInfo)
                }
            })
            .disposed(by: disposeBag)
    }
}


extension SelectableEmojiViewController {
    private func createDataSource() -> RxCollectionViewSectionedReloadDataSource<SelectableReactionSection.Model> {
        return RxCollectionViewSectionedReloadDataSource<SelectableReactionSection.Model>(
            configureCell: { (_, collectionView, indexPath, item) in
                switch item {
                case .realEmoji(let data):
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectableEmojiCollectionViewCell.id, for: indexPath) as? SelectableEmojiCollectionViewCell else {
                        return UICollectionViewCell()
                    }
                    cell.setData(index: indexPath.row, data: data)
                    return cell
                case .standard(let data):
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectableEmojiCollectionViewCell.id, for: indexPath) as? SelectableEmojiCollectionViewCell else {
                        return UICollectionViewCell()
                    }
                    cell.setData(data: data)
                    return cell
                }
            })
    }
}

extension SelectableEmojiViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 44, height: 44)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellSpacing = 12
        let cellWidth = 44
        
        let cellCount = section == 0 ? 5 : 6
        
        let totalCellWidth = cellWidth * cellCount
        let totalSpacingWidth = cellSpacing * (cellCount - 1)

        let leftInset = (collectionView.frame.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset

        return UIEdgeInsets(top: 0, left: leftInset, bottom: 24, right: rightInset)
    }
}
