//
//  ReactionViewController.swift
//  App
//
//  Created by 마경미 on 28.01.24.
//

import UIKit

import Core

import RxSwift
import RxCocoa
import RxDataSources

final class ReactionViewController: BaseViewController<TempReactor>, UICollectionViewDelegateFlowLayout {
    let postId: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
    private let selectedReactionSubject: PublishSubject<Void> = PublishSubject<Void>()
    
    private let reactionCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let reactionCollectionViewLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    let longPressGesture = UILongPressGestureRecognizer(target: nil, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reactionCollectionView.addGestureRecognizer(longPressGesture)
    }

    override func bind(reactor: TempReactor) {
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    override func setupUI() {
        super.setupUI()
        
        view.addSubviews(reactionCollectionView)
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        
        reactionCollectionView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.verticalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        view.backgroundColor = .clear
        
        reactionCollectionViewLayout.do {
            $0.sectionInset = .init(top: 0, left: 13, bottom: 0, right: 13)
            $0.itemSize = .init(width: (UIScreen.main.bounds.width - 26 - (6 * 5)) / 6, height: 36)
            $0.minimumLineSpacing = 12
            $0.minimumInteritemSpacing = 6
        }
        
        reactionCollectionView.do {
            $0.backgroundColor = .clear
            $0.collectionViewLayout = reactionCollectionViewLayout
            $0.semanticContentAttribute = .forceRightToLeft
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.isScrollEnabled = false
            $0.register(AddReactionCollectionViewCell.self, forCellWithReuseIdentifier: AddReactionCollectionViewCell.id)
            $0.register(ReactionCollectionViewCell.self, forCellWithReuseIdentifier: ReactionCollectionViewCell.id)
            $0.register(AddCommentCollectionViewCell.self, forCellWithReuseIdentifier: AddCommentCollectionViewCell.id)
        }
    }
}

extension ReactionViewController {
    private func bindInput(reactor: TempReactor) {
        reactionCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        postId
            .distinctUntilChanged()
            .map { Reactor.Action.acceptPostId($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        selectedReactionSubject
            .withLatestFrom(postId)
            .map { Reactor.Action.fetchReactionList($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        Observable.zip(reactionCollectionView.rx.itemSelected, reactionCollectionView.rx.modelSelected(ReactionSection.Item.self))
            .throttle(RxConst.throttleInterval, scheduler: MainScheduler.instance)
            .map { (indexPath, model) in
                switch model {
                case .main(let emojiData):
                    return Reactor.Action.selectCell(indexPath, emojiData)
                case .addComment:
                    return Reactor.Action.tapComment
                case .addReaction:
                    return Reactor.Action.tapAddEmoji
                }
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        longPressGesture.rx.event
            .map { [weak self] gestureRecognizer -> IndexPath? in
                guard let self = self else { return nil }
                let touchPoint = gestureRecognizer.location(in: self.reactionCollectionView)
                return self.reactionCollectionView.indexPathForItem(at: touchPoint)
            }
            .compactMap { $0 }
            .map { Reactor.Action.longPressEmoji($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: TempReactor) {
        reactor.state.map { $0.reactionSections }
            .map(Array.init(with:))
            .distinctUntilChanged()
            .bind(to: reactionCollectionView.rx.items(dataSource: createDataSource()))
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isShowingReactionMemberSheet)
            .filter { !$0.isEmpty }
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind(onNext: {
                let vc = ReactionMemberDIContainer().makeViewController(memberIds: $0.1)
                $0.0.presentCustomSheetViewController(viewController: vc, useCustomDetent: false)
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isShowingEmojiSheet)
            .filter { $0 }
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .withLatestFrom(postId)
            .withUnretained(self) { ($0, $1) }
            .bind(onNext: {
                let vc = SelectableEmojiDIContainer().makeViewController(postId: $0.1, subject: self.selectedReactionSubject)
                $0.0.presentCustomSheetViewController(viewController: vc, detentHeightRatio: 0.25)
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isShowingCommentSheet)
            .filter { $0 }
           .withUnretained(self)
           .observe(on: MainScheduler.instance)
           .withLatestFrom(postId)
           .withUnretained(self) { ($0, $1) }
           .bind(onNext: {
               let vc = PostCommentDIContainer( postId: $0.1, commentCount: 4).makeViewController()
               $0.0.presentCustomSheetViewController(viewController: vc, detentHeightRatio: 0.85)
           })
           .disposed(by: disposeBag)
    }
    
    private func presentCustomSheetViewController<T: UIViewController>(
        viewController: T,
        detentHeightRatio: CGFloat = 0.0,
        useCustomDetent: Bool = true
    ) {
        if let sheet = viewController.sheetPresentationController {
            if #available(iOS 16.0, *), useCustomDetent {
                let customId = UISheetPresentationController.Detent.Identifier("customId")
                let customDetents = UISheetPresentationController.Detent.custom(identifier: customId) {
                    return $0.maximumDetentValue * detentHeightRatio
                }
                sheet.detents = [customDetents, .large()]
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            } else {
                sheet.detents = [ .medium(), .large()]
                sheet.prefersGrabberVisible = true
            }
        }

        self.present(viewController, animated: true)
    }
    
    private func createDataSource() -> RxCollectionViewSectionedReloadDataSource<ReactionSection.Model> {
        return RxCollectionViewSectionedReloadDataSource<ReactionSection.Model>(
            configureCell: { (_, collectionView, indexPath, item) in
                switch item {
                case .main(let data):
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReactionCollectionViewCell.id, for: indexPath) as? ReactionCollectionViewCell else {
                        return UICollectionViewCell()
                    }
                    cell.reactor = TempCellReactor(items: data)
                    return cell
                case .addComment:
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddCommentCollectionViewCell.id, for: indexPath) as? AddCommentCollectionViewCell else {
                        return UICollectionViewCell()
                    }
                    return cell
                case .addReaction:
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddReactionCollectionViewCell.id, for: indexPath) as? AddReactionCollectionViewCell else {
                        return UICollectionViewCell()
                    }
                    return cell
                }
            })
    }
}