//
//  BBToolTip.swift
//  Core
//
//  Created by 김도현 on 10/27/24.
//

import UIKit

import SnapKit

public final class BBToolTip: NSObject, BBComponentPresentable {
    
    // MARK: - Properties
    public var contentView: BBBaseToolTipView?
    public let superview: UIView?
    public var toolTipStyle: BBToolTipType {
        didSet {
            contentView?.removeFromSuperview()
            
            createToolTipContent(toolTipStyle) { [weak self] in
                guard let superview = self?.superview,
                        let contentView = self?.contentView
                else { return }
                superview.addSubview(contentView)
                self?.updateLayout()
                self?.contentView?.layoutIfNeeded()
            }
        }
    }
    
    // MARK: - Intializer
    public init(
        _ toolTipStyle: BBToolTipType = .activeCameraTime,
        superView: UIView
    ) {
        self.toolTipStyle = toolTipStyle
        self.superview = superView
        super.init()
        createToolTipContent(toolTipStyle)
    }
    
    // MARK: - Configure
    public func updateLayout() {
        guard let superview else {
            assertionFailure("No superview assigned to BBToolTip")
            return
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
    
    private func createToolTipContent(_ style: BBToolTipType, completion: (() -> Void)? = nil) {
        switch style {
        case .waitingSurvivalImage:
            self.contentView = BBThumbnailToolTipView(toolTipType: style)
        default:
            self.contentView = BBTextToolTipView(toolTipType: style)
        }
        
        completion?()
    }
}
