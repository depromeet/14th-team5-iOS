//
//  BBToolTip.swift
//  Core
//
//  Created by 김도현 on 10/27/24.
//

import UIKit

import SnapKit

public final class BBToolTip: NSObject, BBComponentPresentable {
    typealias Content = BBBaseToolTipView
    
    //MARK: Properties
    public var contentView: BBBaseToolTipView?
    public let superview: UIView?
    public var toolTipStyle: BBToolTipType {
        didSet {
            contentView?.removeFromSuperview()
            createToolTipContent(toolTipStyle)
            
            guard let superview else { return }
            if let contentView = contentView {
                superview.addSubview(contentView)
                updateLayout()
                contentView.layoutIfNeeded()
            }
        }
    }
    
    
    public init(
        _ toolTipStyle: BBToolTipType = .activeCameraTime,
        superView: UIView
    ) {
        self.toolTipStyle = toolTipStyle
        self.superview = superView
        super.init()
        createToolTipContent(toolTipStyle)
    }
    
    public func updateLayout() {
        guard let superview else {
            fatalError("SuperView not Created")
        }
        
        switch toolTipStyle {
        case .contributor, .monthlyCalendar:
            
            contentView?.snp.makeConstraints {
                $0.top.equalTo(superview.snp.bottom)
                $0.left.equalToSuperview().offset(20)
            }
        case .familyNameEdit:
            contentView?.snp.makeConstraints {
                $0.bottom.equalTo(superview.snp.top)
                $0.left.equalToSuperview()
            }
        default:
            contentView?.snp.makeConstraints {
                $0.bottom.equalTo(superview.snp.top)
                $0.centerX.equalToSuperview()
            }
        }
    }
    
    
    private func createToolTipContent(_ style: BBToolTipType) {
        switch style {
        case .waitingSurvivalImage:
            self.contentView = BBThumbnailToolTipView(toolTipType: style)
        default:
            self.contentView = BBTextToolTipView(toolTipType: style)
        }
    }
}
