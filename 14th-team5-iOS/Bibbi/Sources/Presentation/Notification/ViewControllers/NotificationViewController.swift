//
//  NotificationViewController.swift
//  App
//
//  Created by 마경미 on 04.01.25.
//

import Core
import UIKit

import RxSwift
import RxDataSources

final class NotificationCell: BaseTableViewCell<NotificationCellReactor> {
    static let id = "notificationCell"
    
    private let contentTopStackView: UIStackView = UIStackView()
    private let profileView: BBProfileImage = BBProfileImage(size: .medium)
    private let titleLabel: BBLabel = BBLabel(.body2Regular)
    private let contentLabel: BBLabel = BBLabel(.body2Regular)
    private let timeLabel: BBLabel = BBLabel(.caption)
    
    var reactor: NotificationCellReactor?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupUI() {
        addSubviews(profileView, contentTopStackView, contentLabel)
        
        contentTopStackView.addArrangedSubviews(titleLabel, timeLabel)
    }
    
    override func setupAutoLayout() {
        profileView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(14)
        }
        
        contentTopStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalTo(profileView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(contentTopStackView.snp.bottom)
            $0.directionalHorizontalEdges.equalTo(contentTopStackView)
        }
    }
    
    override func setupAttributes() {
        
    }
}

extension NotificationCell {
    private func bindInput(reactor: NotificationCellReactor) {
        Observable.just(())
            .map { Reactor.Action.setCell }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: NotificationCellReactor) {
        reactor.state.map { $0.profile }
            .bind(to: profileView.rx.configure)
            .disposed(by: disposeBag)
    }
}

extension NotificationCell {
    internal func setReactor(reactor: NotificationCellReactor) {
        self.reactor = reactor
        
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
}

final class NotificationViewController: BBNavigationViewController<NotificationReactor> {
    private typealias RxDataSource = RxTableViewSectionedReloadDataSource<NotificationSectionModel>
    
    private let divider: UIView = UIView()
    private lazy var tableView: UITableView = UITableView()
    private lazy var footerView: UITableViewHeaderFooterView = UITableViewHeaderFooterView()
    
    private lazy var dataSource: RxDataSource = {
        return RxDataSource { dataSource, tableView, indexPath, reactor in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.id, for: indexPath) as? NotificationCell else {
                return UITableViewCell()
            }
            cell.setReactor(reactor: reactor)
            return cell
        }
    }()
    
    public override func bind(reactor: NotificationReactor) {
        super.bind(reactor: reactor)
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    override func setupUI() {
        super.setupUI()
        
        contentView.addSubview(tableView)
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        
        navigationBar.do {
            $0.navigationTitle = "알림"
            $0.leftBarButtonItem = .arrowLeft
        }
        
        tableView.do {
            $0.register(NotificationCell.self, forCellReuseIdentifier: NotificationCell.id)
        }
    }
}

extension NotificationViewController {
    private func bindInput(reactor: Reactor) {
        
        Observable<Void>.just(())
            .map { Reactor.Action.fetchNotifications }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .map { Reactor.Action.didTapNotificationCell($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: Reactor) {
        reactor.pulse(\.$notificationDataSource)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}
