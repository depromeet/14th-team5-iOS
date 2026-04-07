//
//  StudioThemeTableViewCell.swift
//  Bibbi
//
//  Created by 마경미 on 19.02.26.
//

import UIKit

import Core
import DesignSystem
import Domain
import Kingfisher

import RxDataSources
import RxSwift
import SnapKit

final class StudioThemeTableViewCell: UITableViewCell {
    static let id = "StudioThemeTableViewCell"

    private let headerView = UIView()
    private let themeLabel = BBLabel()
    private let themeContainerView = UIView()
    private let dateLabel = BBLabel(.head2Bold, textColor: .gray200)
    private let infoButton = UIButton()
    private let toolTipView: BBToolTip = BBToolTip(.monthlyCalendar)
    private let bannerImageView = UIImageView()
    private let countLabel = BBLabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
        setupAutoLayout()
        setupAttributes()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension StudioThemeTableViewCell {
    func setupUI() {
        themeContainerView.addSubview(themeLabel)
        contentView.addSubviews(bannerImageView, headerView)
        headerView.addSubviews(themeContainerView, dateLabel, infoButton, countLabel)
    }

    func setupAutoLayout() {
        themeContainerView.snp.makeConstraints {
            $0.width.equalTo(49)
            $0.height.equalTo(24)
            $0.left.equalToSuperview()
            $0.centerY.equalToSuperview()
        }

        themeLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(2)
            $0.horizontalEdges.equalToSuperview().inset(6)
        }

        dateLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(themeContainerView.snp.trailing).offset(6)
        }

        infoButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
            $0.leading.equalTo(dateLabel.snp.trailing).offset(4)
        }

        countLabel.snp.makeConstraints {
            $0.trailing.centerY.equalToSuperview()
            $0.height.equalTo(24)
        }

        headerView.snp.makeConstraints {
            $0.horizontalEdges.top.equalToSuperview()
            $0.height.equalTo(65)
        }

        bannerImageView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(220)
        }
    }

    func setupAttributes() {
        backgroundColor = .clear
        selectionStyle = .none

        themeContainerView.do {
            $0.backgroundColor = .gray400
            $0.layer.cornerRadius = 12
            $0.clipsToBounds = true
        }

        themeLabel.do {
            $0.fontStyle = .body2Bold
            $0.textAlignment = .center
            $0.textColor = .black
        }

        countLabel.do {
            $0.textColor = .gray200
            $0.fontStyle = .body1Regular
            $0.textAlignment = .right
        }

        infoButton.do {
            $0.addTarget(self, action: #selector(didTapInfo), for: .touchUpInside)
            $0.setImage(DesignSystemAsset.infoCircleFill.image, for: .normal)
            $0.layer.zPosition = -1
        }

        toolTipView.do {
            $0.superview = infoButton
        }

        bannerImageView.do {
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 24
        }
    }

    @objc func didTapInfo() {
        toolTipView.isHidden.toggle()
    }
}

extension StudioThemeTableViewCell {
    func configure(_ data: StudioThemeEntity) {
        if let url = URL(string: data.imageURL) {
            bannerImageView.kf.setImage(with: url)
        } else {
            bannerImageView.image = DesignSystemAsset.emptyCaseGraphicEmoji.image
        }

        dateLabel.text = data.startDate + "~" + data.endDate
        themeLabel.text = data.theme
        countLabel.text = "[\(data.postCount)개]의 추억"
    }
}
