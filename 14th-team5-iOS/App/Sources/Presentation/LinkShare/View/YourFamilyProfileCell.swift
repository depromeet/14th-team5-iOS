//
//  FamilyProfileCell.swift
//  App
//
//  Created by 김건우 on 12/12/23.
//

import UIKit

import Core
import ReactorKit
import RxCocoa
import RxSwift
import RxDataSources
import SnapKit
import Then

final class YourFamilyProfileCell: BaseTableViewCell<YourFamilProfileCellReactor> {
    // MARK: - Views
    let profileImageView: UIImageView = UIImageView()
    
    let labelStackView: UIStackView = UIStackView()
    let nameLabel: UILabel = UILabel()
    let meLabel: UILabel = UILabel()
    
    // MARK: - Properties
    static let id: String = "YourFamilyProfileCell"
    
    // MARK: - Intializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    override func setupUI() {
        super.setupUI()
        contentView.addSubviews(
            profileImageView, labelStackView
        )
        
        labelStackView.addArrangedSubviews(
            nameLabel, meLabel
        )
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        profileImageView.snp.makeConstraints {
            $0.leading.equalTo(contentView.snp.leading).offset(LinkShareCell.AutoLayout.profileImageLeadingOffsetValue)
            $0.top.equalTo(contentView.snp.top).offset(LinkShareCell.AutoLayout.profileImageTopOffsetValue)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-LinkShareCell.AutoLayout.profileImageTopOffsetValue)
            $0.width.height.equalTo(LinkShareCell.AutoLayout.profileImageWidthValue)
        }
        
        labelStackView.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(LinkShareCell.AutoLayout.profileImageLeadingOffsetValue)
            $0.centerY.equalTo(profileImageView.snp.centerY)
        }
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        profileImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = LinkShareCell.AutoLayout.profileImageWidthValue / 2.0
        }
        
        labelStackView.do {
            $0.axis = .vertical
            $0.spacing = 8.0
            $0.alignment = .fill
            $0.distribution = .fillProportionally
        }
        
        nameLabel.do {
            $0.textColor = UIColor.white
            $0.font = UIFont.systemFont(ofSize: LinkShareCell.Attribute.nameLabelFontSize)
        }
        
        meLabel.do {
            $0.textColor = UIColor.secondaryLabel
            $0.font = UIFont.systemFont(ofSize: LinkShareCell.Attribute.meLabelFontSize)
        }
        
        contentView.backgroundColor = UIColor(red: 0.09, green: 0.09, blue: 0.09, alpha: 1)
    }
    
    override func bind(reactor: YourFamilProfileCellReactor) {
        super.bind(reactor: reactor)
        profileImageView.kf.setImage(with: URL(string: reactor.currentState.imageUrl))
        nameLabel.text = reactor.currentState.name
        meLabel.text = reactor.currentState.isMe ? "ME" : ""
        
        if !reactor.currentState.isMe {
            labelStackView.spacing = .zero
        }
    }
}
