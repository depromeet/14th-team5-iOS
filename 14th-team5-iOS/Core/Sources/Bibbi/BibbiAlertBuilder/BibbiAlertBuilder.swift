//
//  BibbiAlertBuilder.swift
//  Core
//
//  Created by 김건우 on 4/18/24.
//

import DesignSystem
import UIKit

public final class BibbiAlertBuilder {
    
    // MARK: - Properties
    private let baseViewController: UIViewController?
    private let alertViewController: BibbiAlertViewController = BibbiAlertViewController()
    
    private var subTitle: BibbiAlertTitle?
    private var mainTitle: BibbiAlertTitle?
    private var image: DesignSystemImages.Image?
    
    private var confirmAction: BibbiAlertAction?
    private var cancelAction: BibbiAlertAction?
    
    // MARK: - Intializer
    public init(_ baseViewController: UIViewController?) {
        self.baseViewController = baseViewController
    }
    
    // MARK: - Helpers
    public func setMainTitle(
        _ text: String,
        textColor: UIColor = .gray100,
        fontStyle: BibbiFontStyle = .head2Bold
    ) -> Self {
        mainTitle = BibbiAlertTitle(
            text: text,
            textColor: textColor,
            fontStyle: fontStyle
        )
        return self
    }
    
    public func setSubTitle(
        _ text: String,
        textColor: UIColor = .gray300,
        fontStyle: BibbiFontStyle = .body2Regular
    ) -> Self {
        subTitle = BibbiAlertTitle(
            text: text,
            textColor: textColor,
            fontStyle: fontStyle
        )
        return self
    }
    
    public func setImage(_ designSystemImage: DesignSystemImages.Image) -> Self {
        image = designSystemImage
        return self
    }
    
    public func setConfirmAction(
        _ text: String,
        textColor: UIColor = .bibbiBlack,
        backgroundColor: UIColor = .mainYellow,
        fontStyle: BibbiFontStyle = .body1Bold,
        action: Action = nil
    ) -> Self {
        confirmAction = BibbiAlertAction(
            text: text,
            textColor: textColor,
            backgroundColor: backgroundColor,
            fontStlye: fontStyle,
            action: action
        )
        return self
    }
    
    public func setCancelAction(
        _ text: String,
        textColor: UIColor = .gray400,
        backgroundColor: UIColor = .gray700,
        fontStyle: BibbiFontStyle = .body1Bold,
        action: Action = nil
    ) -> Self {
        cancelAction = BibbiAlertAction(
            text: text,
            textColor: textColor,
            backgroundColor: backgroundColor,
            fontStlye: fontStyle,
            action: action
        )
        return self
    }
    
    
    public func alertStyle(_ style: BibbiAlertStyle) -> Self {
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
