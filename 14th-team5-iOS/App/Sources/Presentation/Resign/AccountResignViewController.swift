//
//  AccountResignViewCotroller.swift
//  App
//
//  Created by Kim dohyun on 1/1/24.
//

import UIKit

import Core
import DesignSystem
import RxCocoa
import ReactorKit
import RxDataSources
import SnapKit
import Then

final class AccountResignViewController: BaseViewController<AccountResignViewReactor> {
    
    private let resignDesrptionLabel: BBLabel = BBLabel(.body1Regular, textColor: .gray400)
    private let resignReasonLabel: BBLabel = BBLabel(.head1, textColor: .gray200)
    private let resignExampleLabel: BBLabel = BBLabel(.body1Regular, textColor: .gray400)
    private let reasonTableView: UITableView = UITableView()
    private let resignIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
    private let confirmButton: UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BBLogManager.analytics(logType: BBEventAnalyticsLog.viewPage(pageName: .resign))
    }
    
    override func setupUI() {
        super.setupUI()
        view.addSubviews(resignDesrptionLabel, resignReasonLabel, resignExampleLabel, confirmButton, resignIndicatorView, reasonTableView)
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        navigationBarView.do {
            $0.setNavigationView(leftItem: .arrowLeft, centerItem: .label("회원 탈퇴"), rightItem: .empty)
        }
        
        resignDesrptionLabel.do {
            $0.textAlignment = .left
            $0.numberOfLines = 1
            $0.text = "삐삐 서비스와 헤어지게 되어 아쉬워요.."
        }
        
        resignReasonLabel.do {
            $0.textAlignment = .left
            $0.numberOfLines = 0
            $0.text = "탈퇴 사유를 알려주세요.\n삐삐 서비스를 개선하는데 많은 도움이 됩니다.\n더 나은 서비스가 될 수 있도록 노력할게요!"
        }
        
        resignExampleLabel.do {
            $0.textAlignment = .left
            $0.numberOfLines = 1
            $0.text = "최소 1개 이상 선택해 주세요."
        }
        
        resignIndicatorView.do {
            $0.hidesWhenStopped = true
            $0.color = .gray
        }
        
        reasonTableView.do {
            $0.separatorStyle = .none
            $0.backgroundColor = .clear
            $0.rowHeight = 52
            $0.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
            $0.register(ResignReaonsTableViewCell.self, forCellReuseIdentifier: "ResignReaonsTableViewCell")
        }
        
        confirmButton.do {
            $0.layer.cornerRadius = 28
            $0.clipsToBounds = true
            $0.setTitle("탈퇴 하기", for: .normal)
            $0.titleLabel?.font = DesignSystemFontFamily.Pretendard.semiBold.font(size: 16)
            $0.setTitleColor(DesignSystemAsset.black.color, for: .normal)
            $0.backgroundColor = DesignSystemAsset.mainYellow.color.withAlphaComponent(0.2)
            $0.isEnabled = false
        }
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        
        reasonTableView.snp.makeConstraints {
            $0.top.equalTo(resignExampleLabel.snp.bottom).offset(16)
            $0.left.equalToSuperview()
            $0.height.equalTo(260)
            $0.centerX.equalTo(navigationBarView)
        }
        
        resignDesrptionLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom).offset(26)
            $0.left.equalToSuperview().offset(16)
            $0.centerX.equalTo(navigationBarView)
            $0.height.equalTo(18)
        }
        
        resignReasonLabel.snp.makeConstraints {
            $0.top.equalTo(resignDesrptionLabel.snp.bottom).offset(24)
            $0.left.equalToSuperview().offset(12)
            $0.height.equalTo(99)
            $0.width.equalTo(242)
        }
        
        resignExampleLabel.snp.makeConstraints {
            $0.top.equalTo(resignReasonLabel.snp.bottom).offset(24)
            $0.left.equalToSuperview().offset(12)
            $0.height.equalTo(18)
            $0.centerX.equalTo(navigationBarView)
        }
        
        confirmButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(56)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin)
        }
        
    }
    
    override func bind(reactor: AccountResignViewReactor) {
        super.bind(reactor: reactor)
        
        Observable.just(())
            .map { Reactor.Action.viewDidLoad}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        confirmButton
            .rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: {$0.0.showResignAlertController()})
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$reasonSectionModel)
            .bind(to: reasonTableView.rx.items(dataSource: createDataSource()))
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.reasonType != .none }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { $0.0.setupButton(isSelected: $0.1)})
            .disposed(by: disposeBag)
        
        reasonTableView.rx.modelSelected(ResignReasonTableViewCellReactor.self)
            .map { $0.currentState.reasonType }
            .map { Reactor.Action.didTappedReasonButton($0)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
    }
}


extension AccountResignViewController {
    private func setupButton(isSelected: Bool) {
        confirmButton.backgroundColor = isSelected ? DesignSystemAsset.mainYellow.color : DesignSystemAsset.mainYellow.color.withAlphaComponent(0.2)
        confirmButton.isEnabled = isSelected
    }
    
    private func showResignAlertController() {
        let resignAlertController = UIAlertController(
            title: "회원 탈퇴",
            message: "회원을 탈퇴해도 나의 활동 내역은 \n유지됩니다. 정말 탈퇴하시겠습니까?",
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
            resignAlertController.dismiss(animated: true)
        }
        
        let confirmAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            guard let self else { return }
            BBLogManager.analytics(logType: BBEventAnalyticsLog.clickAccountButton(entry: .resign))
            self.reactor?.action.onNext(.didTapResignButton)
        }
        
        [cancelAction, confirmAction].forEach(resignAlertController.addAction(_:))
        resignAlertController.overrideUserInterfaceStyle = .dark
        present(resignAlertController, animated: true)
    }
}

extension AccountResignViewController {
    private func createDataSource() -> RxTableViewSectionedReloadDataSource<AccountResignSectionModel> {
        return RxTableViewSectionedReloadDataSource<AccountResignSectionModel> { datasource, tableView, indexPath, reactor in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResignReaonsTableViewCell") as? ResignReaonsTableViewCell else {
                return UITableViewCell()
            }
            cell.reactor = reactor
            return cell
        }
    }
}
