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
    public var superview: UIView?
    public var isHidden: Bool = true {
        didSet { isHidden ? self.hide() : self.show() }
    }
    
    public var toolTipStyle: BBToolTipType {
        didSet {
            contentView?.removeFromSuperview()
            createToolTipContent(toolTipStyle) { [weak self] in
                guard let superview = self?.superview,
                        let contentView = self?.contentView
                else { return }
                superview.addSubview(contentView)
                self?.updateLayout()
            }
        }
    }
    
    // MARK: - Intializer
    public init(
        _ toolTipStyle: BBToolTipType = .activeCameraTime
    ) {
        self.toolTipStyle = toolTipStyle
        super.init()
        createToolTipContent(toolTipStyle)
    }
    
    // MARK: - Configure
    public func updateLayout() {
        guard let superview = superview, let contentView = contentView else {
            assertionFailure("No superview or contentView assigned to BBToolTip")
            return
        }
        
        superview.layoutIfNeeded()
        contentView.layoutIfNeeded()
        
        contentView.frame.size = contentView.intrinsicContentSize

        let superviewCenterX = superview.bounds.midX
        let contentViewWidth = contentView.frame.width
        let arrowTipXPosition = toolTipStyle.configure.xPosition.rawValue * contentViewWidth

        let horizontalOffset = superviewCenterX - arrowTipXPosition
 
        var contentViewFrame = contentView.frame
        switch toolTipStyle {
        case .contributor, .monthlyCalendar:
            contentViewFrame.origin = CGPoint(
                x: horizontalOffset,
                y: superview.bounds.origin.y + superview.frame.height
            )
        case .familyNameEdit:
            contentViewFrame.origin = CGPoint(
                x: horizontalOffset + superview.bounds.midX,
                y: superview.bounds.minY - contentView.frame.height
            )
        default:
            contentViewFrame.origin = CGPoint(
                x: horizontalOffset,
                y: superview.bounds.minY - contentView.frame.height
            )
        }
        
        contentView.frame = contentViewFrame
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
