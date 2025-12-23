//
//  StudioBannerView.swift
//  Bibbi
//
//  Created by 마경미 on 24.09.25.
//

// TODO: to design system
import UIKit

import Core
import DesignSystem

import RxCocoa
import RxSwift

final class StudioBannerView: UIView {
    struct Configure {
        let theme: String?
        let date: String?
        let bannerImage: UIImage?
    }
    
    let configure: Configure = .init(
        theme: "성탄절",
        date: "12/23~12/31",
        bannerImage: DesignSystemAsset.studioBanner.image
    )
    
    private let headerView = UIView()
    private let themeLabel = BBLabel()
    private let themeContainerView = UIView()
    private let dateLabel = BBLabel(.head2Bold, textColor: .gray200)
    private let infoButton = UIButton()
    private let toolTipView: BBToolTip = BBToolTip(.monthlyCalendar)
    public var countLabel = BBLabel()
    private let bannerImageView = UIImageView()
    
    fileprivate let bannerTapGesture = UITapGestureRecognizer()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupAutoLayout()
        setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupAutoLayout()
        setupAttributes()
    }
}

extension StudioBannerView {
    private func setupUI() {
        themeContainerView.addSubview(themeLabel)
        addSubviews(bannerImageView, headerView)
        headerView.addSubviews(themeContainerView, dateLabel,
                               infoButton, countLabel)
    }
    
    private func setupAutoLayout() {
        // TODO: Label 안쪽에 Padding으로 변경 필요
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
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(220)
        }
    }
    
    private func setupAttributes() {
        themeContainerView.do {
            $0.backgroundColor = .gray400
            $0.layer.cornerRadius = 12
            $0.clipsToBounds = true
        }
        
        themeLabel.do {
            $0.text = configure.theme
            $0.fontStyle = .body2Bold
            $0.textAlignment = .center
            $0.textColor = .black
        }
        
        countLabel.do {
            $0.textColor = .gray200
            $0.fontStyle = .body1Regular
            $0.textAlignment = .right
        }
        
        dateLabel.do {
            $0.text = configure.date
            $0.sizeToFit()
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
            $0.image = configure.bannerImage
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(bannerTapGesture)
            $0.layer.cornerRadius = 24
        }
    }
    
    @objc func didTapInfo() {
        toolTipView.isHidden.toggle()
    }
}

extension Reactive where Base: StudioBannerView {
    var imageTap: ControlEvent<Void> {
        let events = base.bannerTapGesture.rx.event
            .filter { $0.state == .ended }
            .map { _ in () }
        return ControlEvent(events: events)
    }
    
    var count: Binder<Int?> {
        Binder(base) { view, count in
            if let c = count {
                view.countLabel.text = "[\(c)]개의 추억"
            } else {
                view.countLabel.text = nil
            }
        }
    }
}
