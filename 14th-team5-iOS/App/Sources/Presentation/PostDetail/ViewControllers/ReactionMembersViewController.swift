//
//  ReactionMembersViewController.swift
//  App
//
//  Created by 마경미 on 06.01.24.
//

import UIKit
import Core
import DesignSystem

import RxSwift
import RxDataSources

final class ReactionMembersViewController: BaseViewController<ReactionMemberReactor> {
    private let headerView: UIView = UIView()
    private let reactionImageView: UIImageView = UIImageView()
    private let reactionLabel: UILabel = BibbiLabel(.head2Bold)
    private let memberTableView: UITableView = UITableView()
    private let closeButton: UIButton = UIButton()
    
    // 임시 memberId 배열 => tableview에 연결하고, 해당 memberId -> userdefaults에서 출력하기!
    let data: PublishSubject<[String]> = PublishSubject<[String]>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func bind(reactor: ReactionMemberReactor) {
        data.map { "총 \($0.count)명이 반응을 남겼어요" }
            .bind(to: reactionLabel.rx.text)
            .disposed(by: disposeBag)
        
//        data
//            .bind(to: memberTableView.rx.items(dataSource: createDataSource($0)))
//            .disposed(by: disposeBag)
    }
    
    override func setupUI() {
        super.setupUI()
        
        view.addSubviews(headerView, memberTableView, closeButton)
        headerView.addSubviews(reactionImageView, reactionLabel)
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        
        headerView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(90)
        }
        
        reactionImageView.snp.makeConstraints {
            $0.size.equalTo(42)
            $0.leading.equalToSuperview().inset(24)
            $0.centerY.equalToSuperview()
        }
        
        reactionLabel.snp.makeConstraints {
            $0.leading.equalTo(reactionImageView.snp.trailing).offset(20)
            $0.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(25)
            $0.centerY.equalToSuperview()
        }
        
        memberTableView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalTo(memberTableView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.height.equalTo(56)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(6)
        }
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        
        reactionImageView.do {
            $0.image = DesignSystemAsset.emoji4.image
        }

        memberTableView.do {
            $0.backgroundColor = .clear
        }
        
        closeButton.do {
            $0.layer.cornerRadius = 28
            $0.backgroundColor = .mainGreen
            $0.titleLabel?.font = DesignSystemFontFamily.Pretendard.semiBold.font(size: 16)
            $0.setTitle("닫기", for: .normal)
            $0.setTitleColor(.black, for: .normal)
        }
    }
}

extension ReactionMembersViewController {
    private func createDataSource() -> RxTableViewSectionedReloadDataSource<SectionOfFamilyMemberProfile> {
        return RxTableViewSectionedReloadDataSource<SectionOfFamilyMemberProfile> { datasource, tableView, indexPath, memberResponse in
            let cell = tableView.dequeueReusableCell(withIdentifier: FamilyMemberProfileCell.id, for: indexPath) as! FamilyMemberProfileCell
            cell.reactor = FamilyMemberProfileCellDIContainer(member: memberResponse).makeReactor()
            return cell
        }
    }
}
