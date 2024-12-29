//
//  LinkShareViewController.swift
//  App
//
//  Created by 김건우 on 12/11/23.
//

import Core
import DesignSystem
import UIKit
import Util

import ReactorKit
import RxCocoa
import RxDataSources
import RxSwift
import SnapKit
import Then


public final class ManagementViewController: BBNavigationViewController<ManagementReactor> {
    
    // MARK: - Typealias
    
    private typealias RxDataSource = RxTableViewSectionedReloadDataSource<FamilyMemberSectionModel>
    
    
    // MARK: - Views
    
    private lazy var sharingContainerView: SharingContainerView = makeSharingContainerView()
    private let divider: UIView = UIView()
    
    private lazy var memberTableHeaderView: ManagementTableHeaderView = makeMengementTableHeaderView()
    private lazy var memberTableView: ManagementTableView = makeManagementTableView()
    
    
    // MARK: - Properties
    
    private lazy var dataSource: RxDataSource = {
        prepareDatasource()
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        BBLogManager.analytics(logType: BBEventAnalyticsLog.viewPage(pageName: .familyManagement))
    }
    
    
    // MARK: - Helpers
    
    public override func bind(reactor: ManagementReactor) {
        super.bind(reactor: reactor)
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: ManagementReactor) {
        Observable<Void>.just(())
            .map { Reactor.Action.fetchFamilyGroupInfo }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        Observable<Void>.just(())
            .map { Reactor.Action.fetchPaginationFamilyMemeber(refresh: false) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        navigationBar.rx.didTapRightBarButton
            .map { _ in Reactor.Action.didTapSettingBarButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        sharingContainerView.rx.tap
            .throttle(RxInterval._300milliseconds, scheduler: MainScheduler.instance)
            .map { Reactor.Action.didTapSharingContainer }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        memberTableView.rx.itemSelected
            .map { Reactor.Action.didSelectTableCell($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        memberTableView.rx.didPullDownRefreshControl
            .throttle(RxInterval._300milliseconds, scheduler: RxScheduler.main)
            .map { _ in Reactor.Action.fetchPaginationFamilyMemeber(refresh: true) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        memberTableHeaderView.rx.didTapFamilyNameEditButton
            .throttle(RxInterval._300milliseconds, scheduler: RxScheduler.main)
            .map { _ in Reactor.Action.didTapFamilyNameEditButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: ManagementReactor) {
        reactor.pulse(\.$memberDatasource)
            .bind(to: memberTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.hiddenSharingProgressHud }
            .distinctUntilChanged()
            .bind(with: self) { $0.sharingContainerView.hiddenSharingProgressHud(hidden: $1) }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.hiddenTableProgressHud }
            .distinctUntilChanged()
            .bind(with: self) { $0.memberTableView.hiddenTableProgressHud(hidden: $1) }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.hiddenMemberFetchFailureView }
            .distinctUntilChanged()
            .bind(with: self) { $0.memberTableView.hiddenFetchFailureView(hidden: $1) }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isRefreshing)
            .delay(RxInterval._700milliseconds, scheduler: RxScheduler.main)
            .bind(with: self) { owner, _ in owner.memberTableView.endRefreshing() }
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.familyName }
            .distinctUntilChanged()
            .bind(with: self) { $0.memberTableHeaderView.setFamilyName($1) }
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.memberCount}
            .distinctUntilChanged()
            .bind(with: self) { $0.memberTableHeaderView.setMemberCount($1) }
            .disposed(by: disposeBag)
    }
    
    public override func setupUI() {
        super.setupUI()
        
        view.addSubviews(sharingContainerView, divider, memberTableHeaderView, memberTableView)
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        
        sharingContainerView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(90)
        }
        
        divider.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.top.equalTo(sharingContainerView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview()
        }
        
        memberTableHeaderView.snp.makeConstraints {
            $0.height.equalTo(73)
            $0.top.equalTo(divider.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }
        
        memberTableView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(memberTableHeaderView.snp.bottom).offset(8)
            $0.bottom.equalToSuperview()
        }
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        
        navigationBar.do {
            $0.navigationTitle = "가족"
            $0.navigationTitleFontStyle = .head2Bold
            $0.leftBarButtonItem = .arrowLeft
            $0.rightBarButtonItem = .setting
         }
        
        divider.do {
            $0.backgroundColor = UIColor.gray600
        }
        
    }
}


// MARK: - Extensions

extension ManagementViewController {

    // TODO: - 코드 리팩토링하기
    private func makeSharingContainerView() -> SharingContainerView {
        return SharingContainerView(
            reactor: SharingContainerReactor()
        )
    }
    
    private func makeMengementTableHeaderView() -> ManagementTableHeaderView {
        return ManagementTableHeaderView(
            reactor: ManagementTableHeaderReactor()
        )
    }
    
    private func makeManagementTableView() -> ManagementTableView {
        return ManagementTableView(
            reactor: ManagementTableReactor()
        )
    }
    
}

extension ManagementViewController {
    
    private func prepareDatasource() -> RxDataSource {
        return RxDataSource { datasource, tableView, indexPath, reactor in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: FamilyMemberCell.id,
                for: indexPath
            ) as! FamilyMemberCell
            cell.reactor = reactor
            return cell
        }
    }
    
}
