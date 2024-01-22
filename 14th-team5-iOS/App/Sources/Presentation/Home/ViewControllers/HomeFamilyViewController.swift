//
//  HomeFamilyViewController.swift
//  App
//
//  Created by 마경미 on 13.01.24.
//

import UIKit

import Core
import Domain

import RxDataSources

final class HomeFamilyViewController: BaseViewController<HomeFamilyViewReactor> {
    private let inviteFamilyView: InviteFamilyView = InviteFamilyView(openType: .makeUrl)
    private let familyCollectionViewLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private let familyCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let dataSource: RxCollectionViewSectionedReloadDataSource<FamilySection.Model>  = {
        return RxCollectionViewSectionedReloadDataSource<FamilySection.Model>(
            configureCell: { (_, collectionView, indexPath, item) in
                switch item {
                case .main(let data):
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FamilyCollectionViewCell.id, for: indexPath) as? FamilyCollectionViewCell else {
                        return UICollectionViewCell()
                    }
                    cell.setCell(data: data)
                    return cell
                }
            })
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit {
        print("deinit HomeViewController")
    }
    
    override func bind(reactor: HomeFamilyViewReactor) {
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    override func setupUI() {
        view.addSubviews(familyCollectionView)
    }
    
    override func setupAutoLayout() {
        familyCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setupAttributes() {
        familyCollectionViewLayout.do {
            $0.scrollDirection = .horizontal
            $0.sectionInset = UIEdgeInsets(
                top: HomeAutoLayout.FamilyCollectionView.edgeInsetTop,
                left: HomeAutoLayout.FamilyCollectionView.edgeInsetLeft,
                bottom: HomeAutoLayout.FamilyCollectionView.edgeInsetBottom,
                right: HomeAutoLayout.FamilyCollectionView.edgeInsetRight)
            $0.minimumLineSpacing = HomeAutoLayout.FamilyCollectionView.minimumLineSpacing
        }
        
        familyCollectionView.do {
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.register(FamilyCollectionViewCell.self, forCellWithReuseIdentifier: FamilyCollectionViewCell.id)
            $0.backgroundColor = .clear
            $0.collectionViewLayout = familyCollectionViewLayout
        }
    }
}

extension HomeFamilyViewController {
    private func bindInput(reactor: HomeFamilyViewReactor) {
        familyCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        self.rx.viewWillAppear
            .map { _ in Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        inviteFamilyView.rx.tap
            .throttle(RxConst.throttleInterval, scheduler: Schedulers.main)
            .map { Reactor.Action.tapInviteFamily }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        familyCollectionView.rx.modelSelected(FamilySection.Item.self)
            .compactMap { item -> ProfileData? in
                switch item {
                case .main(let profileData):
                    return profileData
                }
            }
            .withUnretained(self)
            .bind { owner, profileData in
                let profileViewController = ProfileDIContainer(memberId: profileData.memberId).makeViewController()
                self.navigationController?.pushViewController(profileViewController, animated: true)
            }
            .disposed(by: disposeBag)
        
        familyCollectionView.rx.prefetchItems
            .throttle(.seconds(1), scheduler: Schedulers.main)
            .observe(on: Schedulers.main)
            .asObservable()
            .map(dataSource.items(at:))
            .map(Reactor.Action.prefetchItems)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        familyCollectionView.rx.didScroll
            .throttle(.seconds(1), scheduler: Schedulers.main)
            .withLatestFrom(self.familyCollectionView.rx.contentOffset)
            .map { [weak self] in
              Reactor.Action.pagination(
                contentHeight: self?.familyCollectionView.contentSize.height ?? 0,
                contentOffsetY: $0.y,
                scrollViewHeight: UIScreen.main.bounds.height
              )
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: HomeFamilyViewReactor) {
        reactor.state
            .map { $0.familySections }
            .map(Array.init(with:))
            .distinctUntilChanged()
            .bind(to: familyCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isShowingInviteFamilyView }
            .distinctUntilChanged()
            .observe(on: Schedulers.main)
            .withUnretained(self)
            .bind(onNext: { $0.0.setFamilyInviteView($0.1) })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$familyInvitationLink)
            .observe(on: Schedulers.main)
            .withUnretained(self)
            .bind(onNext: {
                $0.0.makeInvitationUrlSharePanel(
                    $0.1,
                    provider: reactor.provider
                )
            })
            .disposed(by: disposeBag)
        
        
        reactor.pulse(\.$shouldPresentCopySuccessToastMessageView)
            .skip(1)
            .withUnretained(self)
            .subscribe {
                $0.0.makeBibbiToastView(
                    text: "링크가 복사되었어요",
                    symbol: "link",
                    width: 210
                )
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$shouldPresentFetchFailureToastMessageView)
            .skip(1)
            .withUnretained(self)
            .subscribe {
                $0.0.makeBibbiToastView(
                    text: "잠시 후에 다시 시도해주세요",
                    symbol: "exclamationmark.triangle.fill",
                    palletteColors: [UIColor.systemYellow],
                    width: 230
                )
            }
            .disposed(by: disposeBag)
    }
}

extension HomeFamilyViewController {
    private func setFamilyInviteView(_ isShow: Bool) {
        if isShow {
            familyCollectionView.isHidden = isShow
            view.addSubview(inviteFamilyView)
            
            inviteFamilyView.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.horizontalEdges.equalToSuperview().inset(HomeAutoLayout.InviteFamilyView.horizontalInset)
                $0.height.equalTo(HomeAutoLayout.InviteFamilyView.height)
            }
        } else {
            inviteFamilyView.removeFromSuperview()
        }
    }
}

extension HomeFamilyViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: HomeAutoLayout.FamilyCollectionView.cellWidth, height: HomeAutoLayout.FamilyCollectionView.cellHeight)
    }
}
