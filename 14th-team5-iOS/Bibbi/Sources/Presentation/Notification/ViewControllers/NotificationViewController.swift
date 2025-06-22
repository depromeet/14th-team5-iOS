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

final class NotificationFooterView: UITableViewHeaderFooterView {
    static let id = "notificationFooterView"
    
    private let leftLineView: UIView = UIView()
    private let labelView: BBLabel = .init(.caption, textColor: .gray500)
    private let rightLineView: UIView = UIView()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
        setupAttributes()
        setupAutoLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubviews(leftLineView, labelView, rightLineView)
    }
    
    private func setupAutoLayout() {
        leftLineView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(10)
        }
        
        labelView.snp.makeConstraints {
            $0.leading.equalTo(leftLineView.snp.trailing).offset(12)
            $0.center.equalToSuperview()
            $0.trailing.equalTo(rightLineView.snp.leading).offset(-12)
        }
        
        rightLineView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(10)
        }
    }
    
    private func setupAttributes() {
        labelView.do {
            $0.text = "최근 한 달 전 알림까지 확인할 수 있어요"
        }
        
        leftLineView.do {
            $0.backgroundColor = .gray700
        }
        
        rightLineView.do {
            $0.backgroundColor = .gray700
        }
    }
}

final class NotificationCell: BaseTableViewCell<NotificationCellReactor> {
    static let id = "notificationCell"
    
    private let profileView: BBProfileImage = BBProfileImage(size: .medium)
    private let titleLabel: BBLabel = BBLabel(.body2Regular, textColor: .bibbiWhite)
    private let contentLabel: BBLabel = BBLabel(.body2Regular, textColor: .gray300)
    private let timeLabel: BBLabel = BBLabel(.caption, textColor: .gray500)
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupUI() {
        addSubviews(
            profileView,
            titleLabel,
            timeLabel,
            contentLabel
        )
    }
    
    override func setupAutoLayout() {
        profileView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(14)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalTo(profileView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.equalTo(titleLabel)
            $0.trailing.equalTo(timeLabel)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
    
    override func setupAttributes() {
        self.backgroundColor = .clear
        
        titleLabel.do {
            $0.numberOfLines = 2
        }
        
        contentLabel.do {
            $0.numberOfLines = 0
        }
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
        
        reactor.state.map { $0.notification.title }
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.notification.content }
            .bind(to: contentLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.time }
            .bind(to: timeLabel.rx.text)
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
    
    private let dividerView: UIView = UIView()
    private let emptyView: BBEmptyView = BBEmptyView(configure: .init(
        text: "아직 알림이 없어요\n생일, 댓글 등 소식이 있으면 알려드릴게요")
    )
    private lazy var tableView: UITableView = UITableView()
    private lazy var footerView: UITableViewHeaderFooterView = UITableViewHeaderFooterView()
    
    private lazy var dataSource: RxDataSource = {
        return RxDataSource(
            configureCell: { _, tableView, indexPath, reactor in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.id, for: indexPath) as? NotificationCell else {
                    return UITableViewCell()
                }
                cell.setReactor(reactor: reactor)
                return cell
            }
        )
    }()
    
    public override func bind(reactor: NotificationReactor) {
        super.bind(reactor: reactor)
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    override func setupUI() {
        super.setupUI()
        
        contentView.addSubviews(
            tableView
        )
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
            $0.register(
                NotificationCell.self,
                forCellReuseIdentifier: NotificationCell.id
            )
            $0.register(
                NotificationFooterView.self,
                forHeaderFooterViewReuseIdentifier: NotificationFooterView.id
            )
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = 100
            
            $0.estimatedSectionFooterHeight = 17
            
            $0.backgroundColor = .clear
            $0.separatorStyle = .none
            
            $0.tableFooterView = NotificationFooterView(
                reuseIdentifier: NotificationFooterView.id
            )
        }
    }
}

extension NotificationViewController {
    private func bindInput(reactor: Reactor) {
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        Observable<Void>.just(())
            .map { Reactor.Action.fetchNotifications }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(NotificationCellReactor.self)
            .map { Reactor.Action.didTapNotificationCell($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: Reactor) {
        reactor.pulse(\.$notificationDataSource)
            .observe(on: MainScheduler.instance)
            .compactMap { $0 }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isShowEmptyCase }.compactMap { $0 }
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .bind(onNext: {
                $0.1 ? $0.0.addEmptyView() : $0.0.removeEmptyView()
            })
            .disposed(by: disposeBag)
    }
}

extension NotificationViewController {
    private func addEmptyView() {
        contentView.addSubview(emptyView)
        
        emptyView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func removeEmptyView() {
        emptyView.removeFromSuperview()
    }
}

extension NotificationViewController: UITableViewDelegate {
//    func tableView(
//        _ tableView: UITableView,
//        viewForFooterInSection section: Int
//    ) -> UIView? {
//        let view = NotificationFooterView(
//            reuseIdentifier: NotificationFooterView.id
//        )
//        
//        return view
//    }
}
