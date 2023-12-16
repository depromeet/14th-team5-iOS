//
//  LinkShareViewController.swift
//  App
//
//  Created by 김건우 on 12/11/23.
//

import UIKit

import Core
import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then

public final class LinkShareViewController: BaseViewController<LinkShareViewReactor> {
    // MARK: - Views
    private let shareView: UIView = UIView()
    private let shareTitleLabel: UILabel = UILabel()
    
    private let copyInvitationUrlButton: UIButton = UIButton(type: .system)
    
    private let tableHeader: UILabel = UILabel()
    private let yourFamilyTableView: UITableView = UITableView()
    
    // MARK: - Properties
    
    
    // MARK: - Lifecycles
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Helpers
    public override func setupUI() {
        super.setupUI()
        view.addSubview(shareView)
        view.addSubviews(
            tableHeader, yourFamilyTableView
        )
        shareView.addSubviews(
            shareTitleLabel, copyInvitationUrlButton
        )
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        shareView.snp.makeConstraints {
            $0.leading.equalTo(view.snp.leading).offset(LinkShareVC.AutoLayout.defaultOffsetValue)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(LinkShareVC.AutoLayout.shareViewTopOffsetValue)
            $0.trailing.equalTo(view.snp.trailing).offset(-LinkShareVC.AutoLayout.defaultOffsetValue)
            $0.height.equalTo(LinkShareVC.AutoLayout.shareViewHeightValue)
        }
        
        shareTitleLabel.snp.makeConstraints {
            $0.top.equalTo(shareView.snp.top).offset(LinkShareVC.AutoLayout.shareTitleLabelTopOffsetValue)
            $0.centerX.equalTo(shareView.snp.centerX)
        }
        
        copyInvitationUrlButton.snp.makeConstraints {
            $0.leading.equalTo(shareTitleLabel.snp.leading)
            $0.trailing.equalTo(shareTitleLabel.snp.trailing)
            $0.bottom.equalTo(shareView.snp.bottom).offset(-LinkShareVC.AutoLayout.defaultOffsetValue)
            $0.height.equalTo(LinkShareVC.AutoLayout.copyShareLinkButtonHeight)
        }
        
        tableHeader.snp.makeConstraints {
            $0.top.equalTo(shareView.snp.bottom).offset(32.0)
            $0.leading.equalTo(shareView.snp.leading)
        }
        
        yourFamilyTableView.snp.makeConstraints {
            $0.leading.equalTo(view.snp.leading)
            $0.top.equalTo(tableHeader.snp.bottom).offset(8.0)
            $0.trailing.equalTo(view.snp.trailing)
            $0.bottom.equalTo(view.snp.bottom)
        }
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        shareView.do {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = LinkShareVC.Attribute.shareViewCornerRadius
            $0.backgroundColor = UIColor.darkGray
        }
        
        shareTitleLabel.do {
            $0.text = LinkShareVC.Strings.shareTitle
            $0.font = UIFont.boldSystemFont(ofSize: LinkShareVC.Attribute.shareTitleFontSize)
            $0.textColor = UIColor.white
            $0.textAlignment = .center
        }
        
        copyInvitationUrlButton.do {
            $0.setTitle(LinkShareVC.Strings.copyShareLinkButtonTitle, for: .normal)
            $0.setTitleColor(UIColor.black, for: .normal)
            $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: LinkShareVC.Attribute.copyShareLinkButtonFontSize)
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = LinkShareVC.Attribute.shareViewCornerRadius
            $0.backgroundColor = UIColor.white
        }
        
        tableHeader.do {
            $0.text = LinkShareVC.Strings.familyTableHeader
            $0.font = UIFont.systemFont(ofSize: LinkShareVC.Attribute.tableHeaderFontSize)
            $0.textColor = UIColor.white
        }
        
        yourFamilyTableView.do {
            $0.separatorStyle = .none
            $0.allowsSelection = false
            $0.estimatedRowHeight = UITableView.automaticDimension
            $0.backgroundColor = UIColor.clear
            
            $0.register(YourFamilyProfileCell.self, forCellReuseIdentifier: YourFamilyProfileCell.id)
        }
        
        navigationItem.title = LinkShareVC.Strings.navgationTitle
        
        yourFamilyTableView.dataSource = self
    }
    
    public override func bind(reactor: LinkShareViewReactor) {
        super.bind(reactor: reactor)
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: LinkShareViewReactor) {
        copyInvitationUrlButton.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { Reactor.Action.didTapInvitationUrlButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: LinkShareViewReactor) {
        reactor.pulse(\.$invitationUrl)
            .withUnretained(self)
            .subscribe {
                $0.0.makeInvitationUrlSharePanel($0.1, provider: reactor.provider)
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$shouldPresentToastMessage)
            .filter { $0 }
            .withUnretained(self)
            .subscribe {
                $0.0.makeRoundedToastView(
                    title: LinkShareVC.Strings.successCopyInvitationUrlToPastboard,
                    systemName: "link",
                    width: 200
                )
            }
            .disposed(by: disposeBag)
    }
}

// NOTE: - 임시 코드
extension LinkShareViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: YourFamilyProfileCell.id, for: indexPath) as! YourFamilyProfileCell
        
        // NOTE: - 더미 데이터
        let imageUrls = [
            "https://cdn.pixabay.com/photo/2023/11/20/13/48/butterfly-8401173_1280.jpg",
            "https://cdn.pixabay.com/photo/2023/11/10/02/30/woman-8378634_1280.jpg",
            "https://cdn.pixabay.com/photo/2023/11/26/08/27/leaves-8413064_1280.jpg",
            "https://cdn.pixabay.com/photo/2023/09/03/17/00/chives-8231068_1280.jpg",
            "https://cdn.pixabay.com/photo/2023/09/25/13/42/kingfisher-8275049_1280.png"
        ]
        let cellModel = TempProfileCellModel(imageUrl: imageUrls.randomElement() ?? "", name: "김건우", isMe: Bool.random())
        
        cell.reactor = YourFamilProfileCellReactor(cellModel)
        return cell
    }
}
