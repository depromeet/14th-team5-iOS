//
//  FamilyProfileCell.swift
//  App
//
//  Created by 김건우 on 12/12/23.
//

import UIKit

import Core
import ReactorKit
import RxSwift
import SnapKit
import Then

final class YourFamilyProfileCell: BaseTableViewCell<YourFamilProfileCellReactor> {
    // MARK: - Views
    private let memberImageView: UIImageView = UIImageView()
    
    private let labelStackView: UIStackView = UIStackView()
    private let memberNameLabel: UILabel = UILabel()
    private let isMeLabel: UILabel = UILabel()
    
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
            memberImageView, labelStackView
        )
        
        labelStackView.addArrangedSubviews(
            memberNameLabel, isMeLabel
        )
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        memberImageView.snp.makeConstraints {
            $0.leading.equalTo(contentView.snp.leading).offset(AddFamiliyCell.AutoLayout.profileImageLeadingOffsetValue)
            $0.top.equalTo(contentView.snp.top).offset(AddFamiliyCell.AutoLayout.profileImageTopOffsetValue)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-AddFamiliyCell.AutoLayout.profileImageTopOffsetValue)
            $0.width.height.equalTo(AddFamiliyCell.AutoLayout.profileImageWidthValue)
        }
        
        labelStackView.snp.makeConstraints {
            $0.leading.equalTo(memberImageView.snp.trailing).offset(AddFamiliyCell.AutoLayout.profileImageLeadingOffsetValue)
            $0.centerY.equalTo(memberImageView.snp.centerY)
        }
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        memberImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = AddFamiliyCell.AutoLayout.profileImageWidthValue / 2.0
        }
        
        labelStackView.do {
            $0.axis = .vertical
            $0.spacing = 3.0
            $0.alignment = .fill
            $0.distribution = .fillProportionally
        }
        
        memberNameLabel.do {
            $0.textColor = UIColor.white
            $0.font = UIFont.systemFont(ofSize: AddFamiliyCell.Attribute.nameLabelFontSize)
        }
        
        isMeLabel.do {
            $0.textColor = UIColor.white
            $0.font = UIFont.systemFont(ofSize: AddFamiliyCell.Attribute.meLabelFontSize)
        }
        
        contentView.backgroundColor = UIColor(red: 0.09, green: 0.09, blue: 0.09, alpha: 1)
    }
    
    override func bind(reactor: YourFamilProfileCellReactor) {
        super.bind(reactor: reactor)
        memberImageView.kf.setImage(with: URL(string: reactor.currentState.imageUrl ?? ""))
        memberNameLabel.text = reactor.currentState.name
        isMeLabel.text = true ? "ME" : ""
        
        if true {
            labelStackView.spacing = .zero
        }
    }
}
