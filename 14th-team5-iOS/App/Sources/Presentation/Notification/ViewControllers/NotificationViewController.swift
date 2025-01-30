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
    
    private let profileView: BibbiProfileView = BibbiProfileView(cornerRadius: 12)
    var reactor: NotificationCellReactor?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NotificationCell {
    private func bindInput() {
        
    }
    
    private func bindOutput() {
        
    }
}

final class NotificationViewController: BBNavigationViewController<NotificationReactor> {
    typealias NotificationSectionModel = SectionModel<String, NotificationCellReactor>
    private typealias RxDataSource = RxTableViewSectionedReloadDataSource<NotificationSectionModel>
    
    private let divider: UIView = UIView()
    private lazy var tableView: UITableView = UITableView()
    private lazy var footerView: UITableViewHeaderFooterView = UITableViewHeaderFooterView()
    
    private lazy var dataSource: RxDataSource = {
        return RxDataSource { dataSource, tableView, indexPath, reactor in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.id, for: indexPath) as? NotificationCell else {
                return UITableViewCell()
            }
            cell.reactor = reactor
            return cell
        }
    }()
    
    public override func bind(reactor: NotificationReactor) {
        super.bind(reactor: reactor)
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    override func setupUI() {
        view.addSubview(tableView)
    }
    
    override func setupAutoLayout() {
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func setupAttributes() {
        navigationBar.do {
            $0.navigationTitle = "알림"
            $0.leftBarButtonItem = .arrowLeft
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
//        reactor.pulse(\.$notificationDataSource)
//            .bind(to: tableView.rx.items(dataSource: dataSource))
//            .disposed(by: disposeBag)
    }
}
