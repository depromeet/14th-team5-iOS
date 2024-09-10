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


// MARK: - Typealias

fileprivate typealias _Str = ManagementStrings


// MARK: - ViewController

public final class ManagementViewController: BBNavigationViewController<ManagementViewReactor> {
    
    // MARK: - Typealias
    
    private typealias RxDataSource = RxTableViewSectionedReloadDataSource<FamilyMemberSectionModel>
    
    
    // MARK: - Views
    
    // 공유 라운드 Rectangle 뷰 따로 빼기 - 뷰 컨트롤러 안에 Wrapper 따로 만들기
    private let shareContainerview: SharingRoundedRectView = InvitationUrlContainerDIContainer().makeView()
    // SharingRoundedRectView
    
    
    // 이거는 뷰 컨트롤러에 냅두기
    private let dividerView: UIView = UIView()
    // divider
    
    // 테이블 뷰로 빼기
    
    // > 테이블 헤더로 뷰 따로 빼기
    private let headerStack: UIStackView = UIStackView()
    private let tableTitleLabel: BBLabel = BBLabel(.head1, textColor: .gray200)
    private let tableEditButton: BBButton = BBButton()
    private let tableCountLabel: BBLabel = BBLabel(.body1Regular, textColor: .gray400)
    
    // > 테이블 뷰로 따로 빼기
    private let familyTableView: UITableView = UITableView() // memberTableView 로 이름 바꾸기
    private let refreshControl: UIRefreshControl = UIRefreshControl() // refreshControl.. 좋은데 커스텀 refresh Control 해보기

    
    
    // BBProgressHUD로 바꾸기
    private let bibbiLottieView: AirplaneLottieView = AirplaneLottieView()
    
    // 이거 따로 빼는거 준비하기
    private let fetchFailureView: BibbiFetchFailureView = BibbiFetchFailureView(type: .family)
    
    
    // MARK: - Properties
    
    private lazy var dataSource: RxDataSource = {
        prepareDatasource()
    }()
    
    // MARK: - Helpers
    
    public override func bind(reactor: ManagementViewReactor) {
        super.bind(reactor: reactor)
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: ManagementViewReactor) {
        Observable<Void>.just(())
            .map { Reactor.Action.fetchPaginationFamilyMemebers(false) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        navigationBar.rx.didTapRightBarButton
            .map { _ in Reactor.Action.didTapPrivacyBarButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        shareContainerview.rx.tap
            .throttle(RxInterval._300milliseconds, scheduler: MainScheduler.instance)
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
        
        tableEditButton.rx.tap
            .throttle(RxConst.milliseconds300Interval, scheduler: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                let familyGroupSettingViewController = FamilyNameSettingViewControllerWrapper().viewController
                owner.navigationController?.pushViewController(familyGroupSettingViewController, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: ManagementViewReactor) {
        
        // 이거 Navigator로 제거하기
        reactor.pulse(\.$shouldPushPrivacyVC)
            .filter { !$0.isEmpty }
            .withUnretained(self)
            .subscribe {
                let privacyVC = PrivacyDIContainer(memberId: $0.1).makeViewController()
                $0.0.navigationController?.pushViewController(privacyVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        // 초대 링크는 Transform으로 전달 받기
        reactor.pulse(\.$familyInvitationUrl)
            .withUnretained(self)
            .subscribe {
                $0.0.makeInvitationUrlSharePanel(
                    $0.1,
                    provider: reactor.provider
                )
            }
            .disposed(by: disposeBag)
        
        // RoundedRectView로 이동하기
        reactor.state.map { "\($0.displayFamilyMemberCount)" }
            .distinctUntilChanged()
            .bind(to: tableCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        // ManagementTableView로 이동하기
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
        
        // Navigator로 이동
        reactor.pulse(\.$shouldPushProfileVC)
            .filter { !$0.isEmpty }
            .withUnretained(self)
            .subscribe {
                let profileViewController = ProfileViewControllerWrapper(memberId: $0.1).viewController
                $0.0.navigationController?.pushViewController(profileViewController, animated: true)
            }
            .disposed(by: disposeBag)
        
        // Navigator로 이동
        reactor.pulse(\.$shouldPresentCopySuccessToastMessageView)
            .filter { $0 }
            .withUnretained(self)
            .subscribe(onNext: { _ in
                BBToast.default(
                    image: DesignSystemAsset.link.image,
                    title: "링크가 복사되었어요"
                ).show()
            })
            .disposed(by: disposeBag)
        
        // Navigator로 이동
        reactor.pulse(\.$shouldPresentUrlFetchFailureToastMessageView)
            .filter { $0 }
            .withUnretained(self)
            .subscribe(onNext: { _ in
                BBToast.style(.error).show()
            })
            .disposed(by: disposeBag)
        
        // Navigator로 이동
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

        // ManagementTableView로 이동 구현
        reactor.pulse(\.$shouldPresentPaperAirplaneLottieView)
            .bind(to: bibbiLottieView.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$shouldPresentFamilyFetchFailureView)
            .bind(to: fetchFailureView.rx.isHidden)
            .disposed(by: disposeBag)
        
        
        // ManagementTableView로 이동 구현
        reactor.pulse(\.$shouldGenerateErrorHapticNotification)
            .filter { $0 }
            .subscribe(onNext: { _ in Haptic.notification(type: .error) })
            .disposed(by: disposeBag)
    }
    
    public override func setupUI() {
        super.setupUI()
        
        // 코드 리팩토링하기
        view.addSubviews(
            shareContainerview,
            dividerView, headerStack, tableEditButton ,familyTableView
        )
        headerStack.addArrangedSubviews(
            tableTitleLabel, tableCountLabel
        )
        familyTableView.addSubviews(bibbiLottieView, fetchFailureView)
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        
        shareContainerview.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(24)
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
        
        tableEditButton.snp.makeConstraints {
            $0.centerY.equalTo(headerStack)
            $0.height.width.equalTo(24)
            $0.right.equalToSuperview().inset(20)
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
        
        navigationBar.do {
            $0.navigationTitle = "가족"
            $0.navigationTitleFontStyle = .head2Bold
            $0.leftBarButtonItem = .arrowLeft
            $0.rightBarButtonItem = .setting
         }
        
        dividerView.do {
            $0.backgroundColor = UIColor.gray600
        }
        
        tableEditButton.do {
            $0.setBackgroundImage(DesignSystemAsset.edit.image, for: .normal)
            $0.setTitle("", for: .normal)
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
            
            $0.register(FamilyMemberCell.self, forCellReuseIdentifier: FamilyMemberCell.id)
        }
        
        fetchFailureView.do {
            $0.isHidden = true
        }
    }
}


// MARK: - Extensions

private extension ManagementViewController {

    
    
}

private extension ManagementViewController {
    
    func prepareDatasource() -> RxTableViewSectionedReloadDataSource<FamilyMemberSectionModel> {
        return RxTableViewSectionedReloadDataSource<FamilyMemberSectionModel> { datasource, tableView, indexPath, reactor in
            let cell = tableView.dequeueReusableCell(withIdentifier: FamilyMemberCell.id, for: indexPath) as! FamilyMemberCell
            cell.reactor = reactor
            return cell
        }
    }
    
}
