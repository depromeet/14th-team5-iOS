//
//  MainStudioViewController.swift
//  Bibbi
//
//  Created by 마경미 on 22.09.25.
//

import UIKit

import Core
import Domain

import RxSwift
import RxCocoa
import RxDataSources

final class StudioPageViewController: ReactorViewController<StudioPageReactor> {
    private let tableView = UITableView()
    
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind(reactor: StudioPageReactor) {
        super.bind(reactor: reactor)
        
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    override func setupUI() {
        super.setupUI()
        
        view.addSubviews(
            tableView
        )
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func setupAttributes() {
        super.setupAttributes()

        tableView.do {
            $0.register(StudioThemeTableViewCell.self, forCellReuseIdentifier: StudioThemeTableViewCell.id)
            $0.separatorStyle = .none
            $0.showsVerticalScrollIndicator = false
            $0.refreshControl = refreshControl
        }
    }
}

extension StudioPageViewController {
    private func bindInput(reactor: StudioPageReactor) {
        self.rx.viewWillAppear
            .map { _ in Reactor.Action.fetchThemeList }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        tableView.rx.modelSelected(StudioThemeEntity.self)
            .map { Reactor.Action.didSelectTheme($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: StudioPageReactor) {
        reactor.pulse(\.$studioSection)
            .observe(on: MainScheduler.instance)
            .map(Array.init(with:))
            .bind(to: tableView.rx.items(dataSource: createDataSource()))
            .disposed(by: disposeBag)
        
//        reactor.state
//            .map { $0.memoriesCount }
//            .distinctUntilChanged()
//            .bind(to: bannerView.rx.count)
//            .disposed(by: disposeBag)
    }
}

extension StudioPageViewController {
    private func createDataSource() -> RxTableViewSectionedReloadDataSource<StudioSection> {
        RxTableViewSectionedReloadDataSource<StudioSection>(
            configureCell: { _, tableView, indexPath, item in
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: StudioThemeTableViewCell.id,
                    for: indexPath
                ) as? StudioThemeTableViewCell else {
                    return UITableViewCell()
                }

                cell.configure(item)
                return cell
            }
        )
    }
}
