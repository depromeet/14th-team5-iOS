//
//  LinkShareViewController.swift
//  App
//
//  Created by 김건우 on 12/11/23.
//

import Core
import DesignSystem
import UIKit

import ReactorKit
import RxCocoa
import RxDataSources
import RxSwift
import SnapKit
import Then

fileprivate typealias _Str = FamilyManagementStrings
public final class FamilyManagementViewController: BaseViewController<FamilyManagementViewReactor> {
    // MARK: - Views
    
    private let shareContainerview: InvitationUrlContainerView = InvitationUrlContainerDIContainer().makeView()
    private let dividerView: UIView = UIView()
    
    private let headerStack: UIStackView = UIStackView()
    private let tableTitleLabel: BibbiLabel = BibbiLabel(.head1, textColor: .gray200)
    private let tableCountLabel: BibbiLabel = BibbiLabel(.body1Regular, textColor: .gray400)
    
    private let familyTableView: UITableView = UITableView()
    private let refreshControl: UIRefreshControl = UIRefreshControl()

    private let bibbiLottieView: AirplaneLottieView = AirplaneLottieView()
    
    private let fetchFailureView: BibbiFetchFailureView = BibbiFetchFailureView(type: .family)
    
    // MARK: - Properties
    private lazy var dataSource: RxTableViewSectionedReloadDataSource<FamilyMemberProfileSectionModel> = prepareDatasource()
    
    // MARK: - Lifecycles
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Helpers
    public override func bind(reactor: FamilyManagementViewReactor) {
        super.bind(reactor: reactor)
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: FamilyManagementViewReactor) {
        Observable<Void>.just(())
            .map { Reactor.Action.fetchPaginationFamilyMemebers(false) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        navigationBarView.rx.rightButtonTap
            .map { _ in Reactor.Action.didTapPrivacyBarButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        shareContainerview.rx.tap
            .throttle(RxConst.milliseconds300Interval, scheduler: MainScheduler.instance)
            .map { Reactor.Action.didTapShareContainer }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        familyTableView.rx.itemSelected
            .map { Reactor.Action.didSelectTableCell($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .map { Reactor.Action.fetchPaginationFamilyMemebers(true) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: FamilyManagementViewReactor) {
        reactor.pulse(\.$shouldPushPrivacyVC)
            .filter { !$0.isEmpty }
            .withUnretained(self)
            .subscribe {
                let privacyVC = PrivacyDIContainer(memberId: $0.1).makeViewController()
                $0.0.navigationController?.pushViewController(privacyVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$familyInvitationUrl)
            .withUnretained(self)
            .subscribe {
                $0.0.makeInvitationUrlSharePanel(
                    $0.1,
                    provider: reactor.provider
                )
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { "\($0.displayFamilyMemberCount)" }
            .distinctUntilChanged()
            .bind(to: tableCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        let familyMember = reactor.pulse(\.$displayFamilyMember).asDriver(onErrorJustReturn: [])
        
        familyMember
            .drive(familyTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        familyMember
            .drive(with: self, onNext: { owner, _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    owner.refreshControl.endRefreshing()
                }
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$shouldPushProfileVC)
            .filter { !$0.isEmpty }
            .withUnretained(self)
            .subscribe {
                let profileVC = ProfileDIContainer(memberId: $0.1).makeViewController()
                $0.0.navigationController?.pushViewController(profileVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$shouldPresentCopySuccessToastMessageView)
            .filter { $0 }
            .withUnretained(self)
            .subscribe {
                $0.0.makeBibbiToastView(
                    text: _Str.sucessCopyInvitationUrlText,
                    image: DesignSystemAsset.link.image
                )
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$shouldPresentUrlFetchFailureToastMessageView)
            .filter { $0 }
            .withUnretained(self)
            .subscribe { $0.0.makeErrorBibbiToastView() }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$shouldPresentFamilyFetchFailureToastMessageView)
            .filter { $0 }
            .withUnretained(self)
            .subscribe {
                $0.0.makeBibbiToastView(
                    text: _Str.fetchFailFamilyText,
                    image: DesignSystemAsset.warning.image
                )
            }
            .disposed(by: disposeBag)

        reactor.pulse(\.$shouldPresentPaperAirplaneLottieView)
            .bind(to: bibbiLottieView.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$shouldPresentFamilyFetchFailureView)
            .bind(to: fetchFailureView.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$shouldGenerateErrorHapticNotification)
            .filter { $0 }
            .subscribe(onNext: { _ in Haptic.notification(type: .error) })
            .disposed(by: disposeBag)
    }
    
    public override func setupUI() {
        super.setupUI()
        view.addSubviews(
            shareContainerview,
            dividerView, headerStack, familyTableView
        )
        headerStack.addArrangedSubviews(
            tableTitleLabel, tableCountLabel
        )
        familyTableView.addSubviews(bibbiLottieView, fetchFailureView)
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        shareContainerview.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(90)
        }
        
        dividerView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.top.equalTo(shareContainerview.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview()
        }
        
        headerStack.snp.makeConstraints {
            $0.leading.equalTo(view).inset(24)
            $0.top.equalTo(dividerView.snp.bottom).offset(28)
        }
        
        familyTableView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(headerStack.snp.bottom).offset(8)
            $0.bottom.equalToSuperview()
        }
        
        bibbiLottieView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalToSuperview().offset(140)
        }
        
        fetchFailureView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(70)
            $0.centerX.equalToSuperview()
        }
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        navigationBarView.do {
            $0.setNavigationView(leftItem: .arrowLeft, centerItem: .label(_Str.mainTitle), rightItem: .setting)
         }
        
        dividerView.do {
            $0.backgroundColor = UIColor.gray600
        }
        
        headerStack.do {
            $0.axis = .horizontal
            $0.spacing = 10
            $0.alignment = .fill
            $0.distribution = .fillProportionally
        }
        
        tableTitleLabel.do {
            $0.text = _Str.headerTitle
        }
        
        tableCountLabel.do {
            $0.text = _Str.headerCount
        }
        
        familyTableView.do {
            $0.separatorStyle = .none
            $0.estimatedRowHeight = UITableView.automaticDimension
            $0.backgroundColor = UIColor.clear
            $0.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
            
            $0.refreshControl = refreshControl
            $0.refreshControl?.tintColor = UIColor.bibbiWhite
            
            $0.register(FamilyMemberProfileCell.self, forCellReuseIdentifier: FamilyMemberProfileCell.id)
        }
        
        fetchFailureView.do {
            $0.isHidden = true
        }
    }
}

// MARK: - Extensions
extension FamilyManagementViewController {
    private func prepareDatasource() -> RxTableViewSectionedReloadDataSource<FamilyMemberProfileSectionModel> {
        return RxTableViewSectionedReloadDataSource<FamilyMemberProfileSectionModel> { datasource, tableView, indexPath, reactor in
            let cell = tableView.dequeueReusableCell(withIdentifier: FamilyMemberProfileCell.id, for: indexPath) as! FamilyMemberProfileCell
            cell.reactor = reactor
            return cell
        }
    }
}
