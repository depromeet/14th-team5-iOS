//
//  LinkShareViewController.swift
//  App
//
//  Created by 김건우 on 12/11/23.
//

import UIKit

import Core
import DesignSystem
import ReactorKit
import RxCocoa
import RxDataSources
import RxSwift
import SnapKit
import Then

public final class InviteFamilyViewController: BaseViewController<InviteFamilyViewReactor> {
    // MARK: - Views
    private let navigationBarView: BibbiNavigationBarView = BibbiNavigationBarView()
    
    private let shareContainerView: UIView = UIView()
    private let envelopeImageView: UIImageView = UIImageView()
    
    private let labelStackView: UIStackView = UIStackView()
    private let inviteFamilyTitleLabel: BibbiLabel = BibbiLabel(.head2Bold, textColor: .gray200)
    private let invitationUrlLabel: BibbiLabel = BibbiLabel(.body2Regular, textColor: .gray300)
    private let shareButton: UIButton = UIButton(type: .system)
    
    private let dividerView: UIView = UIView()
    
    private let headerLabelStackView: UIStackView = UIStackView()
    private let tableTitleLabel: BibbiLabel = BibbiLabel(.head1, textColor: .gray200)
    private let tableCountLabel: BibbiLabel = BibbiLabel(.body1Regular, textColor: .gray400)
    private let tableView: UITableView = UITableView()
    
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
    public override func setupUI() {
        super.setupUI()
        view.addSubviews(
            navigationBarView, shareContainerView
        )
        shareContainerView.addSubviews(
            envelopeImageView, labelStackView, shareButton
        )
        labelStackView.addArrangedSubviews(
            inviteFamilyTitleLabel, invitationUrlLabel
        )
        view.addSubviews(
            dividerView, headerLabelStackView, tableView
        )
        headerLabelStackView.addArrangedSubviews(
            tableTitleLabel, tableCountLabel
        )
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        
        navigationBarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(42.0)
        }
        
        shareContainerView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20.0)
            $0.top.equalTo(navigationBarView.snp.bottom).offset(24.0)
            $0.height.equalTo(90.0)
        }
        
        envelopeImageView.snp.makeConstraints {
            $0.leading.equalTo(shareContainerView.snp.leading).offset(AddFamilyVC.AutoLayout.defaultOffsetValue)
            $0.width.height.equalTo(AddFamilyVC.AutoLayout.imageBackgroundViewHeightValue)
            $0.centerY.equalTo(shareContainerView.snp.centerY)
        }
        
        labelStackView.snp.makeConstraints {
            $0.leading.equalTo(envelopeImageView.snp.trailing).offset(AddFamilyVC.AutoLayout.defaultOffsetValue)
            $0.centerY.equalTo(shareContainerView.snp.centerY)
        }
        
        shareButton.snp.makeConstraints {
            $0.trailing.equalTo(shareContainerView.snp.trailing).offset(-AddFamilyVC.AutoLayout.shareInvitationUrlButtonTrailingOffsetValue)
            $0.width.height.equalTo(23.0)
            $0.centerY.equalTo(shareContainerView.snp.centerY)
        }
        
        dividerView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(shareContainerView.snp.bottom).offset(AddFamilyVC.AutoLayout.dividerViewTopOffsetValue)
            $0.height.equalTo(1.0)
        }
        
        headerLabelStackView.snp.makeConstraints {
            $0.leading.equalTo(view).inset(24.0)
            $0.top.equalTo(dividerView.snp.bottom).offset(AddFamilyVC.AutoLayout.tableHeaderStackViewTopOffsetValue)
        }
        
        tableView.snp.makeConstraints {
            $0.leading.trailing.equalTo(view)
            $0.top.equalTo(headerLabelStackView.snp.bottom).offset(AddFamilyVC.AutoLayout.tableViewTopOffsetValue)
            $0.bottom.equalTo(view.snp.bottom)
        }
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        navigationBarView.do {
            $0.navigationTitle = "가족"
            $0.leftBarButtonItem = .arrowLeft
         }
        
        shareContainerView.do {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 16.0
            $0.backgroundColor = DesignSystemAsset.gray800.color
        }
        
        envelopeImageView.do {
            $0.image = DesignSystemAsset.envelopeBackground.image
            $0.contentMode = .scaleAspectFit
        }
        
        labelStackView.do {
            $0.axis = .vertical
            $0.spacing = 3.0
            $0.alignment = .leading
            $0.distribution = .fillProportionally
        }
        
        inviteFamilyTitleLabel.do {
            $0.text = AddFamilyVC.Strings.addFamilyTitle
        }
        
        invitationUrlLabel.do {
            $0.text = AddFamilyVC.Strings.invitationUrlText
        }
        
        shareButton.do {
            $0.setImage(
                DesignSystemAsset.shareLine.image.withRenderingMode(.alwaysTemplate),
                for: .normal
            )
            $0.tintColor = DesignSystemAsset.gray500.color
        }
        
        dividerView.do {
            $0.backgroundColor = DesignSystemAsset.gray600.color
        }
        
        headerLabelStackView.do {
            $0.axis = .horizontal
            $0.spacing = 10.0
            $0.alignment = .fill
            $0.distribution = .fillProportionally
        }
        
        tableTitleLabel.do {
            $0.text = AddFamilyVC.Strings.tableTitle
        }
        
        tableCountLabel.do {
            $0.text = "0"
        }
        
        tableView.do {
            $0.separatorStyle = .none
            $0.allowsSelection = false
            $0.estimatedRowHeight = UITableView.automaticDimension
            $0.backgroundColor = UIColor.clear
            $0.contentInset = AddFamilyVC.Attribute.tableContentInset
            
            $0.register(FamilyMemberProfileCell.self, forCellReuseIdentifier: FamilyMemberProfileCell.id)
        }
        
        navigationItem.title = AddFamilyVC.Strings.navgationTitle
    }
    
    public override func bind(reactor: InviteFamilyViewReactor) {
        super.bind(reactor: reactor)
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: InviteFamilyViewReactor) {
        Observable<Void>.just(())
            .map { Reactor.Action.fetchFamilyMemebers }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        shareButton.rx.tap
            .throttle(RxConst.throttleInterval, scheduler: MainScheduler.instance)
            .map { Reactor.Action.didTapShareButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: InviteFamilyViewReactor) {
        navigationBarView.rx.didTapLeftBarButton
            .withUnretained(self)
            .subscribe {
                $0.0.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$familyInvitationUrl)
            .withUnretained(self)
            .subscribe {
                $0.0.makeInvitationUrlSharePanel($0.1, provider: reactor.provider)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { "\($0.displayMemberCount)" }
            .distinctUntilChanged()
            .bind(to: tableCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.displayFamilyMembers }
            .distinctUntilChanged(at: \.count)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$shouldPresentCopySuccessToastMessageView)
            .skip(1)
            .withUnretained(self)
            .subscribe {
                $0.0.makeBibbiToastView(
                    text: AddFamilyVC.Strings.successCopyInvitationUrl,
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
                    text: "링크 불러오기 실패",
                    symbol: "exclamationmark.triangle.fill",
                    palletteColors: [UIColor.systemRed],
                    width: 190
                )
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Extensions
extension InviteFamilyViewController {
    private func prepareDatasource() -> RxTableViewSectionedReloadDataSource<FamilyMemberProfileSectionModel> {
        return RxTableViewSectionedReloadDataSource<FamilyMemberProfileSectionModel> { datasource, tableView, indexPath, reactor in
            let cell = tableView.dequeueReusableCell(withIdentifier: FamilyMemberProfileCell.id, for: indexPath) as! FamilyMemberProfileCell
            cell.reactor = reactor
            return cell
        }
    }
}
