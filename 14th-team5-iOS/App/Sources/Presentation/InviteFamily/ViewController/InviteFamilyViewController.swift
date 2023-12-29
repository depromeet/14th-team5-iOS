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
    private let invitationUrlAreaBackgroundView: UIView = UIView()
    private let envelopeImageBackgroundView: UIView = UIView()
    private let envelopeImageView: UIImageView = UIImageView()
    
    private let titleLabelStackView: UIStackView = UIStackView()
    private let inviteFamilyTitleLabel: TypeSystemLabel = TypeSystemLabel(.head2Bold)
    private let invitationUrlLabel: TypeSystemLabel = TypeSystemLabel(.body2Regular)
    private let shareButton: UIButton = UIButton(type: .system)
    
    private let dividerView: UIView = UIView()
    
    private let headerLabelStackView: UIStackView = UIStackView()
    private let tableTitleLabel: TypeSystemLabel = TypeSystemLabel(.head1)
    private let tableCountLabel: TypeSystemLabel = TypeSystemLabel(.body1Regular)
    private let tableView: UITableView = UITableView()
    
    // MARK: - Properties
    lazy var dataSource: RxTableViewSectionedReloadDataSource<SectionOfFamilyMemberProfile> = prepareDatasource()
    
    // MARK: - Lifecycles
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Helpers
    public override func setupUI() {
        super.setupUI()
        view.addSubview(invitationUrlAreaBackgroundView)
        invitationUrlAreaBackgroundView.addSubviews(
            envelopeImageBackgroundView, envelopeImageView, titleLabelStackView, shareButton
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
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        invitationUrlAreaBackgroundView.snp.makeConstraints {
            $0.leading.equalTo(view.snp.leading).offset(AddFamilyVC.AutoLayout.defaultOffsetValue)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(AddFamilyVC.AutoLayout.backgroundViewTopOffsetValue)
            $0.trailing.equalTo(view.snp.trailing).offset(-AddFamilyVC.AutoLayout.defaultOffsetValue)
            $0.height.equalTo(AddFamilyVC.AutoLayout.backgroundViewHeightValue)
        }
        
        envelopeImageBackgroundView.snp.makeConstraints {
            $0.leading.equalTo(invitationUrlAreaBackgroundView.snp.leading).offset(AddFamilyVC.AutoLayout.defaultOffsetValue)
            $0.width.height.equalTo(AddFamilyVC.AutoLayout.imageBackgroundViewHeightValue)
            $0.centerY.equalTo(invitationUrlAreaBackgroundView.snp.centerY)
        }
        
        envelopeImageView.snp.makeConstraints {
            $0.width.height.equalTo(AddFamilyVC.AutoLayout.envelopeImageViewHeightValue)
            $0.center.equalTo(envelopeImageBackgroundView.snp.center)
        }
        
        titleLabelStackView.snp.makeConstraints {
            $0.leading.equalTo(envelopeImageBackgroundView.snp.trailing).offset(AddFamilyVC.AutoLayout.defaultOffsetValue)
            $0.centerY.equalTo(invitationUrlAreaBackgroundView.snp.centerY)
        }
        
        shareButton.snp.makeConstraints {
            $0.trailing.equalTo(invitationUrlAreaBackgroundView.snp.trailing).offset(-AddFamilyVC.AutoLayout.shareInvitationUrlButtonTrailingOffsetValue)
            $0.centerY.equalTo(invitationUrlAreaBackgroundView.snp.centerY)
        }
        
        dividerView.snp.makeConstraints {
            $0.leading.equalTo(view.snp.leading)
            $0.top.equalTo(invitationUrlAreaBackgroundView.snp.bottom).offset(AddFamilyVC.AutoLayout.dividerViewTopOffsetValue)
            $0.trailing.equalTo(view.snp.trailing)
            $0.height.equalTo(1.0)
        }
        
        headerLabelStackView.snp.makeConstraints {
            $0.leading.equalTo(view.snp.leading).offset(AddFamilyVC.AutoLayout.defaultOffsetValue)
            $0.top.equalTo(dividerView.snp.bottom).offset(AddFamilyVC.AutoLayout.tableHeaderStackViewTopOffsetValue)
        }
        
        tableView.snp.makeConstraints {
            $0.leading.equalTo(view.snp.leading)
            $0.top.equalTo(headerLabelStackView.snp.bottom).offset(AddFamilyVC.AutoLayout.tableViewTopOffsetValue)
            $0.trailing.equalTo(view.snp.trailing)
            $0.bottom.equalTo(view.snp.bottom)
        }
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        invitationUrlAreaBackgroundView.do {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = AddFamilyVC.Attribute.backgroundViewCornerRadius
            $0.backgroundColor = DesignSystemAsset.gray800.color
        }
        
        envelopeImageBackgroundView.do {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = AddFamilyVC.AutoLayout.imageBackgroundViewHeightValue / 2.0
            $0.backgroundColor = DesignSystemAsset.mainGreen.color
        }
        
        envelopeImageView.do {
            $0.image = DesignSystemAsset.envelope.image
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
            $0.textTypeSystemColor = .white
            $0.textAlignment = .left
        }
        
        invitationUrlLabel.do {
            $0.text = AddFamilyVC.Strings.invitationUrlText
            $0.textTypeSystemColor = .gray500
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
                    width: 190
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
                    width: 200
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