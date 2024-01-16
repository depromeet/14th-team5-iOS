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
    private let inviteFamilyView: UIView = InviteFamilyView()
    private let familyCollectionViewLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private let familyCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
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
        
        rx.viewWillAppear
            .map { _ in Reactor.Action.getFamilyMembers }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        inviteFamilyView.rx.tap
            .throttle(RxConst.throttleInterval, scheduler: Schedulers.main)
            .map { Reactor.Action.tapInviteFamily }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        familyCollectionView
            .rx.modelSelected(ProfileData.self)
            .map { $0.memberId }
            .withUnretained(self)
            .bind { owner, memberId in
                let profileViewController = ProfileDIContainer(memberId: memberId).makeViewController()
                self.navigationController?.pushViewController(profileViewController, animated: true)
            }.disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: HomeFamilyViewReactor) {
        reactor.state
            .map { $0.familySections }
            .asObservable()
            .bind(to: familyCollectionView.rx.items(dataSource: createFamilyDataSource()))
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
    private func createFamilyDataSource() -> RxCollectionViewSectionedReloadDataSource<SectionModel<String, ProfileData>> {
        return RxCollectionViewSectionedReloadDataSource<SectionModel<String, ProfileData>>(
            configureCell: { (_, collectionView, indexPath, item) in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FamilyCollectionViewCell.id, for: indexPath) as? FamilyCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.setCell(data: item)
                return cell
            })
    }
    
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
