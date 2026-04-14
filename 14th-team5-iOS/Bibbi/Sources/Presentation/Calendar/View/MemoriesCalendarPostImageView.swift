//
//  MemoriesCalendarPostImageView.swift
//  App
//
//  Created by 김건우 on 10/17/24.
//

import Core
import DesignSystem
import UIKit

import Kingfisher
import Then
import SnapKit

final class MemoriesCalendarPostImageView: BaseView<MemoriesCalendarPostImageReactor> {

    // MARK: - Views

    private let imageView: UIImageView = UIImageView()
    private let missionText: MissionTextView = MissionTextView()
    private let locationContainerView = UIView()
    private let locationIconView = UIImageView(image: DesignSystemAsset.location.image)
    private let locationLabel = BBLabel(.body2Bold, textAlignment: .left, textColor: .mainYellow)

    // MARK: - Helpers

    public override func setupUI() {
        super.setupUI()

        addSubviews(imageView, missionText, locationContainerView)
        locationContainerView.addSubviews(locationIconView, locationLabel)
    }

    public override func setupAutoLayout() {
        super.setupAutoLayout()

        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        missionText.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.horizontalEdges.equalToSuperview().inset(32)
            $0.height.equalTo(41)
        }

        locationContainerView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
            $0.height.equalTo(30)
        }

        locationIconView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(14)
        }

        locationLabel.snp.makeConstraints {
            $0.leading.equalTo(locationIconView.snp.trailing).offset(4)
            $0.trailing.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
    }

    public override func setupAttributes() {
        super.setupAttributes()

        imageView.do {
            $0.clipsToBounds = true
            $0.backgroundColor = UIColor.gray100
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 48
        }

        missionText.do {
            $0.isHidden = true
        }

        locationContainerView.do {
            $0.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            $0.layer.cornerRadius = 15
            $0.clipsToBounds = true
            $0.isHidden = true
        }

        locationIconView.do {
            $0.contentMode = .scaleAspectFit
            $0.tintColor = .white
        }
    }

}


// MARK: - Extensions

extension MemoriesCalendarPostImageView {

    func prepareForReuse() {
        imageView.image = nil
        missionText.setHidden(hidden: true)
        locationContainerView.isHidden = true
        locationLabel.text = nil
    }

    func setPostImage(imageUrl url: String) {
        imageView.kf.setImage(with: URL(string: url)!)
    }

    func setMissionText(text: String?) {
        missionText.setHidden(hidden: false)
        missionText.setMissionText(text: text)
    }

    func setLocation(address: String?) {
        if let address, !address.isEmpty {
            locationLabel.text = address
            locationContainerView.isHidden = false
        } else {
            locationContainerView.isHidden = true
        }
    }

}
