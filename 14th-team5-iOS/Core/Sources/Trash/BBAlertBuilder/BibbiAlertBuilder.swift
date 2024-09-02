//
//  BibbiAlertBuilder.swift
//  Core
//
//  Created by 김건우 on 4/18/24.
//

import DesignSystem
import UIKit

@available(*, deprecated, renamed: "BBAlert")
public final class BibbiAlertBuilder {
    
    // MARK: - Properties
    private let baseViewController: UIViewController?
    private let alertViewController: BibbiAlertViewController = BibbiAlertViewController()
    
    private var subTitle: BibbiAlertTitle?
    private var mainTitle: BibbiAlertTitle?
    private var image: DesignSystemImages.Image?
    
    private var confirmAction: BibbiAlertAction?
    private var cancelAction: BibbiAlertAction?
    
    private var alertStyle: BibbiAlertStyle? {
        didSet {
            configureAlertStlye()
        }
    }
    
    // MARK: - Intializer
    public init(_ baseViewController: UIViewController?) {
        self.baseViewController = baseViewController
    }
    
    // MARK: - Helpers
    public func setMainTitle(
        _ text: String? = nil,
        textColor: UIColor = .gray100,
        fontStyle: BBFontStyle = .head2Bold
    ) -> Self {
        mainTitle = BibbiAlertTitle(
            text: text != nil ? text : alertStyle?.mainTitle,
            textColor: textColor,
            fontStyle: fontStyle
        )
        return self
    }
    
    public func setSubTitle(
        _ text: String? = nil,
        textColor: UIColor = .gray300,
        fontStyle: BBFontStyle = .body2Regular
    ) -> Self {
        subTitle = BibbiAlertTitle(
            text: text != nil ? text : alertStyle?.subTitle,
            textColor: textColor,
            fontStyle: fontStyle
        )
        return self
    }
    
    public func setImage(_ designSystemImage: DesignSystemImages.Image? = nil) -> Self {
        image = (designSystemImage != nil ? designSystemImage : alertStyle?.image)
        return self
    }
    
    public func setConfirmAction(
        _ text: String? = nil,
        textColor: UIColor = .bibbiBlack,
        backgroundColor: UIColor = .mainYellow,
        fontStyle: BBFontStyle = .body1Bold,
        action: Action = nil
    ) -> Self {
        confirmAction = BibbiAlertAction(
            text: text != nil ? text : alertStyle?.confirmText,
            textColor: textColor,
            backgroundColor: backgroundColor,
            fontStlye: fontStyle,
            action: action
        )
        return self
    }
    
    public func setCancelAction(
        _ text: String? = nil,
        textColor: UIColor = .gray400,
        backgroundColor: UIColor = .gray700,
        fontStyle: BBFontStyle = .body1Bold,
        action: Action = nil
    ) -> Self {
        cancelAction = BibbiAlertAction(
            text: text != nil ? text : alertStyle?.cancelText,
            textColor: textColor,
            backgroundColor: backgroundColor,
            fontStlye: fontStyle,
            action: action
        )
        return self
    }
    
    
    public func alertStyle(_ style: BibbiAlertStyle) -> Self {
        alertStyle = style
        return self
    }
    
    @discardableResult
    public func present(animated: Bool = true) -> Self {
        alertViewController.modalTransitionStyle = .crossDissolve
        alertViewController.modalPresentationStyle = .overFullScreen
        
        alertViewController.subTitle = subTitle
        alertViewController.mainTitle = mainTitle
        alertViewController.image = image
        alertViewController.confirmAction = confirmAction
        alertViewController.cancelAction = cancelAction
        
        baseViewController?.present(alertViewController, animated: animated)
        return self
    }
    
}

// MARK: - Extensions
extension BibbiAlertBuilder {
    private func configureAlertStlye() {
        setSubTitle()
        setMainTitle()
        setImage()
        setConfirmAction()
        setCancelAction()
    }
}
