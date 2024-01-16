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

public final class FamilyManagementViewController: BaseViewController<FamilyManagementViewReactor> {
    // MARK: - Views
    private let navigationBarView: BibbiNavigationBarView = BibbiNavigationBarView()
    
    private let shareContainerView: UIView = UIView()
    private let envelopeImageView: UIImageView = UIImageView()
    
    private let labelStack: UIStackView = UIStackView()
    private let invitationDescLabel: BibbiLabel = BibbiLabel(.head2Bold, textColor: .gray200)
    private let invitationUrlLabel: BibbiLabel = BibbiLabel(.body2Regular, textColor: .gray300)
    private let shareLineImageView: UIImageView = UIImageView()
    private let indicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    
    private let dividerView: UIView = UIView()
    
    private let headerStack: UIStackView = UIStackView()
    private let tableTitleLabel: BibbiLabel = BibbiLabel(.head1, textColor: .gray200)
    private let tableCountLabel: BibbiLabel = BibbiLabel(.body1Regular, textColor: .gray400)
    private let familyTableView: UITableView = UITableView()
    
    // MARK: - Properties
    lazy var dataSource: RxTableViewSectionedReloadDataSource<FamilyMemberProfileSectionModel> = prepareDatasource()
    
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
            .map { Reactor.Action.fetchFamilyMemebers }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        shareContainerView.rx.tap
            .throttle(RxConst.throttleInterval, scheduler: MainScheduler.instance)
            .map { Reactor.Action.didTapShareButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: FamilyManagementViewReactor) {
        navigationBarView.rx.didTapLeftBarButton
            .withUnretained(self)
            .subscribe {
                $0.0.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { !$0.shouldShowProgressView }
            .distinctUntilChanged()
            .bind(to: indicatorView.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.shouldShowProgressView }
            .distinctUntilChanged()
            .bind(to: indicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.shouldShowProgressView }
            .distinctUntilChanged()
            .bind(to: shareLineImageView.rx.isHidden)
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
        
        reactor.pulse(\.$displayFamilyMemberInfo)
            .bind(to: familyTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$shouldPresentCopySuccessToastMessageView)
            .skip(1)
            .withUnretained(self)
            .subscribe {
                $0.0.makeBibbiToastView(
                    text: FamilyManagementStrings.sucessCopyInvitationUrlText,
                    designSystemImage: DesignSystemAsset.link.image,
                    width: 220
                )
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$shouldPresentFetchFailureToastMessageView)
            .skip(1)
            .withUnretained(self)
            .subscribe {
                $0.0.makeBibbiToastView(
                    text: FamilyManagementStrings.fetchFailInvitationUrlText,
                    designSystemImage: DesignSystemAsset.warning.image,
                    width: 240
                )
            }
            .disposed(by: disposeBag)
    }
    
    public override func setupUI() {
        super.setupUI()
        view.addSubviews(
            navigationBarView, shareContainerView
        )
        shareContainerView.addSubviews(
            envelopeImageView, labelStack, shareLineImageView, indicatorView
        )
        labelStack.addArrangedSubviews(
            invitationDescLabel, invitationUrlLabel
        )
        view.addSubviews(
            dividerView, headerStack, familyTableView
        )
        headerStack.addArrangedSubviews(
            tableTitleLabel, tableCountLabel
        )
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        
        navigationBarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(42)
        }
        
        shareContainerView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalTo(navigationBarView.snp.bottom).offset(24)
            $0.height.equalTo(90)
        }
        
        envelopeImageView.snp.makeConstraints {
            $0.size.equalTo(50)
            $0.leading.equalTo(shareContainerView.snp.leading).offset(16)
            $0.centerY.equalTo(shareContainerView.snp.centerY)
        }
        
        labelStack.snp.makeConstraints {
            $0.leading.equalTo(envelopeImageView.snp.trailing).offset(16)
            $0.centerY.equalTo(shareContainerView.snp.centerY)
        }
        
        shareLineImageView.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.trailing.equalTo(shareContainerView.snp.trailing).offset(-24)
            $0.centerY.equalTo(shareContainerView.snp.centerY)
        }
        
        indicatorView.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.trailing.equalTo(shareContainerView.snp.trailing).offset(-24)
            $0.centerY.equalTo(shareContainerView.snp.centerY)
        }
        
        dividerView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.top.equalTo(shareContainerView.snp.bottom).offset(24)
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
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        navigationBarView.do {
            $0.navigationTitle = FamilyManagementStrings.mainTitle
            $0.leftBarButtonItem = .arrowLeft
         }
        
        shareContainerView.do {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 16
            $0.backgroundColor = .gray800
        }
        
        envelopeImageView.do {
            $0.image = DesignSystemAsset.envelopeBackground.image
            $0.contentMode = .scaleAspectFit
        }
        
        labelStack.do {
            $0.axis = .vertical
            $0.spacing = 3
            $0.alignment = .leading
            $0.distribution = .fillProportionally
        }
        
        invitationDescLabel.do {
            $0.text = FamilyManagementStrings.inviteDescText
        }
        
        invitationUrlLabel.do {
            $0.text = FamilyManagementStrings.invitationUrlText
        }
        
        shareLineImageView.do {
            $0.image = DesignSystemAsset.shareLine.image
            $0.tintColor = .gray500
            $0.contentMode = .scaleAspectFit
        }
        
        indicatorView.do {
            $0.color = .bibbiWhite
            $0.isHidden = true
            $0.style = .medium
        }
        
        dividerView.do {
            $0.backgroundColor = .gray600
        }
        
        headerStack.do {
            $0.axis = .horizontal
            $0.spacing = 10
            $0.alignment = .fill
            $0.distribution = .fillProportionally
        }
        
        tableTitleLabel.do {
            $0.text = FamilyManagementStrings.headerTitle
        }
        
        tableCountLabel.do {
            $0.text = FamilyManagementStrings.headerCount
        }
        
        familyTableView.do {
            $0.separatorStyle = .none
            $0.allowsSelection = false
            $0.estimatedRowHeight = UITableView.automaticDimension
            $0.backgroundColor = UIColor.clear
            $0.contentInset = UIEdgeInsets(
                top: 10, left: 0, bottom: 0, right: 0
            )
            
            $0.register(FamilyMemberProfileCell.self, forCellReuseIdentifier: FamilyMemberProfileCell.id)
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
