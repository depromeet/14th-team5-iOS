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

final class LinkShareViewController: BaseViewController<LinkShareViewReactor> {
    // MARK: - Views
    private let shareView: UIView = UIView()
    private let shareTitleLabel: UILabel = UILabel()
    
    private let shareButtonsStackView: UIStackView = UIStackView()
    
    private let kakaoTalkStackView: UIStackView = UIStackView()
    private let kakaoTalkShareButton: UIButton = UIButton(type: .system)
    private let kakaoTalkLabel: UILabel = UILabel()
    
    private let messageStackView: UIStackView = UIStackView()
    private let messageShareButton: UIButton = UIButton(type: .system)
    private let messageLabel: UILabel = UILabel()
    
    private let instagramStackView: UIStackView = UIStackView()
    private let instagramShareButton: UIButton = UIButton(type: .system)
    private let instagramLabel: UILabel = UILabel()
    
    private let moreStackView: UIStackView = UIStackView()
    private let moreShareButton: UIButton = UIButton(type: .system)
    private let moreLabel: UILabel = UILabel()
    
    private let copyShareLinkButton: UIButton = UIButton(type: .system)
    
    private let tableHeader: UILabel = UILabel()
    private let yourFamilyTableView: UITableView = UITableView()
    
    // MARK: - Properties
    
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Helpers
    override func setupUI() {
        super.setupUI()
        view.addSubview(shareView)
        view.addSubviews(
            tableHeader, yourFamilyTableView
        )
        shareView.addSubviews(
            shareTitleLabel, shareButtonsStackView, copyShareLinkButton
        )
        
        shareButtonsStackView.addArrangedSubviews(
            kakaoTalkStackView, messageStackView, instagramStackView, moreStackView
        )
        kakaoTalkStackView.addArrangedSubviews(
            kakaoTalkShareButton, kakaoTalkLabel
        )
        messageStackView.addArrangedSubviews(
            messageShareButton, messageLabel
        )
        instagramStackView.addArrangedSubviews(
            instagramShareButton, instagramLabel
        )
        moreStackView.addArrangedSubviews(
            moreShareButton, moreLabel
        )
    }
    
    override func setupAutoLayout() {
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
        
        shareButtonsStackView.snp.makeConstraints {
            $0.leading.equalTo(shareView.snp.leading).offset(LinkShareVC.AutoLayout.defaultShareButtonStackOffsetValue)
            $0.top.equalTo(shareTitleLabel.snp.bottom).offset(LinkShareVC.AutoLayout.defaultShareButtonStackOffsetValue)
            $0.trailing.equalTo(shareView.snp.trailing).offset(-LinkShareVC.AutoLayout.defaultShareButtonStackOffsetValue)
        }
        
        kakaoTalkShareButton.snp.makeConstraints {
            $0.width.equalTo(kakaoTalkShareButton.snp.height).multipliedBy(LinkShareVC.AutoLayout.shareButtonMultiplier)
        }
        
        messageShareButton.snp.makeConstraints {
            $0.width.equalTo(messageShareButton.snp.height).multipliedBy(LinkShareVC.AutoLayout.shareButtonMultiplier)
        }
        
        instagramShareButton.snp.makeConstraints {
            $0.width.equalTo(instagramShareButton.snp.height).multipliedBy(LinkShareVC.AutoLayout.shareButtonMultiplier)
        }
        
        moreShareButton.snp.makeConstraints {
            $0.width.equalTo(moreShareButton.snp.height).multipliedBy(LinkShareVC.AutoLayout.shareButtonMultiplier)
        }
        
        copyShareLinkButton.snp.makeConstraints {
            $0.leading.equalTo(shareButtonsStackView.snp.leading)
            $0.trailing.equalTo(shareButtonsStackView.snp.trailing)
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
    
    override func setupAttributes() {
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
        
        shareButtonsStackView.do {
            $0.axis = .horizontal
            $0.spacing = LinkShareVC.Attribute.shareButtonsHorizontalStackSpacing
            $0.alignment = .fill
            $0.distribution = .fillEqually
        }
        
        kakaoTalkStackView.do {
            $0.axis = .vertical
            $0.spacing = LinkShareVC.Attribute.shareButtonsVerticalStackSpacing
            $0.alignment = .fill
            $0.distribution = .fill
        }
        
        kakaoTalkShareButton.do {
            $0.setTitle("이미지", for: .normal)
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = LinkShareVC.Attribute.shareButtonCorenrRadius
            $0.backgroundColor = UIColor.white
        }
        
        kakaoTalkLabel.do {
            $0.text = LinkShareVC.Strings.kakaoTalkButtonTitle
            $0.font = UIFont.systemFont(ofSize: LinkShareVC.Attribute.shareButtonLabelFontSize)
            $0.textColor = UIColor.white
            $0.textAlignment = .center
        }
        
        messageStackView.do {
            $0.axis = .vertical
            $0.spacing = LinkShareVC.Attribute.shareButtonsVerticalStackSpacing
            $0.alignment = .fill
            $0.distribution = .fill
        }
        
        messageShareButton.do {
            $0.setTitle("이미지", for: .normal)
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = LinkShareVC.Attribute.shareButtonCorenrRadius
            $0.backgroundColor = UIColor.white
        }
        
        messageLabel.do {
            $0.text = LinkShareVC.Strings.messageButtonTitle
            $0.font = UIFont.systemFont(ofSize: LinkShareVC.Attribute.shareButtonLabelFontSize)
            $0.textColor = UIColor.white
            $0.textAlignment = .center
        }
        
        instagramStackView.do {
            $0.axis = .vertical
            $0.spacing = LinkShareVC.Attribute.shareButtonsVerticalStackSpacing
            $0.alignment = .fill
            $0.distribution = .fill
        }
        
        instagramShareButton.do {
            $0.setTitle("이미지", for: .normal)
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = LinkShareVC.Attribute.shareButtonCorenrRadius
            $0.backgroundColor = UIColor.white
        }
        
        instagramLabel.do {
            $0.text = LinkShareVC.Strings.instagramButtonTitle
            $0.font = UIFont.systemFont(ofSize: LinkShareVC.Attribute.shareButtonLabelFontSize)
            $0.textColor = UIColor.white
            $0.textAlignment = .center
        }
        
        moreStackView.do {
            $0.axis = .vertical
            $0.spacing = LinkShareVC.Attribute.shareButtonsVerticalStackSpacing
            $0.alignment = .fill
            $0.distribution = .fill
        }
        
        moreShareButton.do {
            $0.setTitle("이미지", for: .normal)
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = LinkShareVC.Attribute.shareButtonCorenrRadius
            $0.backgroundColor = UIColor.white
        }
        
        moreLabel.do {
            $0.text = LinkShareVC.Strings.moreButtonTitle
            $0.font = UIFont.systemFont(ofSize: LinkShareVC.Attribute.shareButtonLabelFontSize)
            $0.textColor = UIColor.white
            $0.textAlignment = .center
        }
        
        copyShareLinkButton.do {
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
    
    override func bind(reactor: LinkShareViewReactor) {
        super.bind(reactor: reactor)
    }
}

// NOTE: - 임시 코드
extension LinkShareViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
