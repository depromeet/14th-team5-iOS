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
    
    private let shareAreaBackgroundView: UIView = UIView()
    private let envelopeImageView: UIImageView = UIImageView()
    
    private let titleLabelStackView: UIStackView = UIStackView()
    private let inviteFamilyTitleLabel: BibbiLabel = BibbiLabel(.head2Bold)
    private let invitationUrlLabel: BibbiLabel = BibbiLabel(.body2Regular)
    private let shareButton: UIButton = UIButton(type: .system)
    
    private let dividerView: UIView = UIView()
    
    private let headerLabelStackView: UIStackView = UIStackView()
    private let tableTitleLabel: BibbiLabel = BibbiLabel(.head1)
    private let tableCountLabel: BibbiLabel = BibbiLabel(.body1Regular)
    private let tableView: UITableView = UITableView()
    
    // MARK: - Properties
    lazy var dataSource: RxTableViewSectionedReloadDataSource<SectionOfFamilyMemberProfile> = prepareDatasource()
    
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
            navigationBarView, shareAreaBackgroundView
        )
        shareAreaBackgroundView.addSubviews(
            envelopeImageView, titleLabelStackView, shareButton
        )
        titleLabelStackView.addArrangedSubviews(
            inviteFamilyTitleLabel, invitationUrlLabel
        )
        view.addSubviews(
            dividerView, headerLabelStackView, tableView
        )
        headerLabelStackView.addArrangedSubviews(
            tableTitleLabel, tableCountLabel
        )
    }
    
    // 세부 UI 수치 조정하기
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        
        navigationBarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(42.0)
        }
        
        shareAreaBackgroundView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.top.equalTo(navigationBarView.snp.bottom).offset(16.0)
            $0.height.equalTo(90.0)
        }
        
        envelopeImageView.snp.makeConstraints {
            $0.leading.equalTo(shareAreaBackgroundView.snp.leading).offset(AddFamilyVC.AutoLayout.defaultOffsetValue)
            $0.width.height.equalTo(AddFamilyVC.AutoLayout.imageBackgroundViewHeightValue)
            $0.centerY.equalTo(shareAreaBackgroundView.snp.centerY)
        }
        
        titleLabelStackView.snp.makeConstraints {
            $0.leading.equalTo(envelopeImageView.snp.trailing).offset(AddFamilyVC.AutoLayout.defaultOffsetValue)
            $0.centerY.equalTo(shareAreaBackgroundView.snp.centerY)
        }
        
        shareButton.snp.makeConstraints {
            $0.trailing.equalTo(shareAreaBackgroundView.snp.trailing).offset(-AddFamilyVC.AutoLayout.shareInvitationUrlButtonTrailingOffsetValue)
            $0.centerY.equalTo(shareAreaBackgroundView.snp.centerY)
        }
        
        dividerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(shareAreaBackgroundView.snp.bottom).offset(AddFamilyVC.AutoLayout.dividerViewTopOffsetValue)
            $0.height.equalTo(1.0)
        }
        
        headerLabelStackView.snp.makeConstraints {
            $0.leading.equalTo(view).inset(20.0)
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
        
        shareAreaBackgroundView.do {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 16.0
            $0.backgroundColor = DesignSystemAsset.gray800.color
        }
        
        envelopeImageView.do {
            $0.image = DesignSystemAsset.envelopeBackground.image
            $0.contentMode = .scaleAspectFit
        }
        
        titleLabelStackView.do {
            $0.axis = .vertical
            $0.spacing = 3.0
            $0.alignment = .leading
            $0.distribution = .fillProportionally
        }
        
        inviteFamilyTitleLabel.do {
            $0.text = AddFamilyVC.Strings.addFamilyTitle
            $0.textBibbiColor = .white
            $0.textAlignment = .left
        }
        
        invitationUrlLabel.do {
            $0.text = AddFamilyVC.Strings.invitationUrlText
            $0.textBibbiColor = .gray500
            $0.textAlignment = .left
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
            
            $0.register(FamiliyMemberProfileCell.self, forCellReuseIdentifier: FamiliyMemberProfileCell.id)
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
            .map { Reactor.Action.fetchYourFamilyMemeber }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        navigationBarView.rx.didTapLeftBarButton
            .withUnretained(self)
            .subscribe {
                $0.0.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        shareButton.rx.tap
            .throttle(RxConst.throttleInterval, scheduler: MainScheduler.instance)
            .map { Reactor.Action.didTapInvitationUrlButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: InviteFamilyViewReactor) {
        reactor.state.map { $0.familyDatasource }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        reactor.state.map { "\($0.familyMemberCount)" }
            .distinctUntilChanged()
            .bind(to: tableCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$invitationUrl)
            .withUnretained(self)
            .subscribe {
                $0.0.makeInvitationUrlSharePanel($0.1, provider: reactor.provider)
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$shouldPresentFetchInvitationUrlFailureToastMessage)
            .filter { $0 }
            .throttle(.seconds(3), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .subscribe {
                $0.0.makeRoundedToastView(
                    title: "링크 불러오기 실패",
                    symbol: "exclamationmark.triangle.fill",
                    palletteColors: [UIColor.systemRed],
                    width: 194
                )
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$shouldPresentInvitationUrlCopySuccessToastMessage)
            .filter { $0 }
            .withUnretained(self)
            .subscribe {
                $0.0.makeRoundedToastView(
                    title: AddFamilyVC.Strings.successCopyInvitationUrl,
                    symbol: "link",
                    width: 210
                )
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Extensions
extension InviteFamilyViewController {
    func prepareDatasource() -> RxTableViewSectionedReloadDataSource<SectionOfFamilyMemberProfile> {
        return RxTableViewSectionedReloadDataSource<SectionOfFamilyMemberProfile> { datasource, tableView, indexPath, memberResponse in
            let cell = tableView.dequeueReusableCell(withIdentifier: FamiliyMemberProfileCell.id, for: indexPath) as! FamiliyMemberProfileCell
            cell.reactor = FamilyMemberProfileCellDIContainer().makeReactor(memberResponse)
            return cell
        }
    }
}
