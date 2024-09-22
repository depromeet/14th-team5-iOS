//
//  BBToastService.swift
//  Core
//
//  Created by 김건우 on 9/22/24.
//

import UIKit

import RxSwift

// MARK: - ServiceType

public protocol BBToastServiceType {
    func show(
        _ title: String,
        titleColor: UIColor?,
        titleFontStyle: BBFontStyle?,
        viewConfig: BBToastViewConfiguration,
        config: BBToastConfiguration
    )
    
    func show(
        image: UIImage,
        imageTint: UIColor?,
        title: String,
        titleColor: UIColor?,
        titleFontStyle: BBFontStyle?,
        viewConfig: BBToastViewConfiguration,
        config: BBToastConfiguration
    )
    
    func show(
        image: UIImage?,
        imageTint: UIColor?,
        title: String,
        titleColor: UIColor?,
        titleFontStyle: BBFontStyle?,
        buttonTitle: String,
        buttonTitleFontStyle: BBFontStyle?,
        buttonTint: UIColor?,
        viewConfig: BBToastViewConfiguration,
        config: BBToastConfiguration
    ) -> Observable<Void>
    
    func show(
        _ style: BBToastStyle,
        config: BBToastConfiguration
    )
}

extension BBToastServiceType {
    
    public func show(
        _ title: String,
        titleColor: UIColor? = nil,
        titleFontStyle: BBFontStyle? = nil,
        viewConfig: BBToastViewConfiguration = BBToastViewConfiguration(),
        config: BBToastConfiguration = BBToastConfiguration()
    ) {
        BBToast.text(
            title,
            titleColor: titleColor,
            titleFontStyle: titleFontStyle,
            viewConfig: viewConfig,
            config: config
        ).show()
    }
    
    public func show(
        image: UIImage,
        imageTint: UIColor? = nil,
        title: String,
        titleColor: UIColor? = nil,
        titleFontStyle: BBFontStyle? = nil,
        viewConfig: BBToastViewConfiguration = BBToastViewConfiguration(),
        config: BBToastConfiguration = BBToastConfiguration()
    ) {
        BBToast.default(
            image: image,
            imageTint: imageTint,
            title: title,
            titleColor: titleColor,
            titleFontStyle: titleFontStyle,
            viewConfig: viewConfig,
            config: config
        ).show()
    }
    
    @discardableResult
    public func show(
        image: UIImage? = nil,
        imageTint: UIColor? = nil,
        title: String,
        titleColor: UIColor? = nil,
        titleFontStyle: BBFontStyle? = nil,
        buttonTitle: String,
        buttonTitleFontStyle: BBFontStyle? = nil,
        buttonTint: UIColor? = nil,
        viewConfig: BBToastViewConfiguration = BBToastViewConfiguration(),
        config: BBToastConfiguration = BBToastConfiguration()
    ) -> Observable<Void> {

        return Observable<Void>.create { observer in
            let action: BBToastActionHandler = { toast in
                observer.onNext(())
                toast?.close()
            }
            
            let toast = BBToast.button(
                image: image,
                imageTint: imageTint,
                title: title,
                titleColor: titleColor,
                titleFontStyle: titleFontStyle,
                buttonTitle: buttonTitle,
                buttonTitleFontStyle: buttonTitleFontStyle,
                buttonTint: buttonTint,
                action: action,
                viewConfig: viewConfig,
                config: config
            )
            
            toast.show()
            
            return Disposables.create {
                toast.close()
            }
        }
        
    }
    
    public func show(
        _ style: BBToastStyle,
        config: BBToastConfiguration = BBToastConfiguration()
    ) {
        BBToast.style(
            style,
            config: config
        ).show()
    }
    
}


// MARK: - BBToastService

public class BBToastService: BaseService, BBToastServiceType { }


