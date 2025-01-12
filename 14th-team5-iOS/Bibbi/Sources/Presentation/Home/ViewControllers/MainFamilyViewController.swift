//
//  MainFamilyViewController.swift
//  App
//
//  Created by 마경미 on 20.04.24.
//

import UIKit

import Core
import Domain
import DesignSystem

import RxSwift
import RxCocoa
import RxDataSources

final class MainFamilyViewController: BaseViewController<MainFamilyViewReactor> {
    private let inviteFamilyView: InviteFamilyView = InviteFamilyView(openType: .makeUrl)
    private let familyCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    let familySectionRelay: PublishSubject<[FamilySection.Item]> = PublishSubject()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarView.isHidden = true
    }
    
    override func bind(reactor: MainFamilyViewReactor) {
        super.bind(reactor: reactor)
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    override func setupUI() {
        super.setupUI()
        
        view.addSubviews(familyCollectionView, inviteFamilyView)
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        
        familyCollectionView.snp.makeConstraints {
            $0.height.equalTo(138)
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        inviteFamilyView.snp.makeConstraints {
            $0.top.equalTo(familyCollectionView).inset(24)
            $0.horizontalEdges.equalTo(familyCollectionView).inset(20)
            $0.height.equalTo(90)
        }
        
        familyCollectionView.do {
            $0.collectionViewLayout = createFamilyLayout()
            $0.showsHorizontalScrollIndicator = false
            $0.backgroundColor = .clear
            $0.register(MainFamilyCollectionViewCell.self, forCellWithReuseIdentifier: MainFamilyCollectionViewCell.id)
        }
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        
        inviteFamilyView.do {
            $0.isHidden = true
        }
    }
}

extension MainFamilyViewController {
    private func bindInput(reactor: MainFamilyViewReactor) {
        familySectionRelay
            .skip(1)
            .map { Reactor.Action.updateFamilySection($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        inviteFamilyView.rx.tap
            .throttle(RxConst.milliseconds300Interval, scheduler: RxSchedulers.main)
            .map { Reactor.Action.tapInviteFamily }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        familyCollectionView.rx.modelSelected(FamilySection.Item.self)
            .throttle(RxConst.milliseconds300Interval, scheduler: MainScheduler.instance)
            .compactMap { item -> FamilyMemberProfileEntity? in
                switch item {
                case let .main(reactor): return reactor.currentState.profileData
                }
            }
            .withUnretained(self)
            .bind { owner, profileData in
                let profileViewController = ProfileViewControllerWrapper(memberId: profileData.memberId).viewController
                self.navigationController?.pushViewController(profileViewController, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: MainFamilyViewReactor) {
        reactor.pulse(\.$familySection)
            .observe(on: MainScheduler.instance)
            .map(Array.init(with:))
            .bind(to: familyCollectionView.rx.items(dataSource: createFamilyDataSource()))
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isShowingInviteFamilyView)
            .observe(on: MainScheduler.instance)
            .map { !$0 }
            .distinctUntilChanged()
            .bind(to: inviteFamilyView.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isShowingInviteFamilyView)
            .observe(on: MainScheduler.instance)
            .map { $0 }
            .distinctUntilChanged()
            .bind(to: familyCollectionView.rx.isHidden)
            .disposed(by: disposeBag)
        
//        reactor.pulse(\.$familyInvitationLink)
//            .observe(on: RxSchedulers.main)
//            .withUnretained(self)
//            .bind(onNext: {
//                $0.0.makeInvitationUrlSharePanel(
//                    $0.1,
//                    provider: reactor.provider
//                )
//            })
//            .disposed(by: disposeBag)
        
        reactor.pulse(\.$shouldPresentFetchFailureToastMessageView)
            .filter {  $0 }
            .bind(with: self) { owner, _ in
                owner.makeErrorBibbiToastView()
            }
            .disposed(by: disposeBag)
    }
    
    private func createFamilyLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = .init(width: 64, height: 90)
        layout.sectionInset = UIEdgeInsets(
            top: HomeAutoLayout.FamilyCollectionView.edgeInsetTop,
            left: HomeAutoLayout.FamilyCollectionView.edgeInsetLeft,
            bottom: HomeAutoLayout.FamilyCollectionView.edgeInsetBottom,
            right: HomeAutoLayout.FamilyCollectionView.edgeInsetRight)
        layout.minimumLineSpacing = HomeAutoLayout.FamilyCollectionView.minimumLineSpacing
        return layout
    }
    
    private func createFamilyDataSource() -> RxCollectionViewSectionedReloadDataSource<FamilySection.Model>  {
        return RxCollectionViewSectionedReloadDataSource<FamilySection.Model>(
            configureCell: { (_, collectionView, indexPath, item) in
                switch item {
                case let .main(reactor):
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainFamilyCollectionViewCell.id, for: indexPath) as? MainFamilyCollectionViewCell else {
                        return UICollectionViewCell()
                    }
                    cell.reactor = reactor
                    return cell
                }
            })
    }
}
