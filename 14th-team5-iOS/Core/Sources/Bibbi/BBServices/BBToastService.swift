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

public extension BBToastServiceType {
    
    /// 텍스트가 포함된 Toast를 생성합니다.
    /// - Parameters:
    ///   - title: 타이틀 텍스트
    ///   - titleColor: 타이틀 색상
    ///   - titleFontStyle: 타이틀의 폰트 스타일
    ///   - viewConfig: ToastView 설정값
    ///   - config: Toast 설정값
    func show(
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
    
    /// 이미지와 텍스트가 포함된 Toast를 생성합니다,
    /// - Parameters:
    ///   - image: 이미지
    ///   - imageTint: 이미지 강조 색상
    ///   - title: 타이틀 텍스트
    ///   - titleColor: 타이틀 색상
    ///   - titleFontStyle: 타이틀의 폰트 스타일
    ///   - viewConfig: ToastView 설정값
    ///   - config: Toast 설정값
    func show(
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
    
    /// 이미지, 텍스트와 버튼이 포함된 Toast를 생성합니다.
    /// - Parameters:
    ///   - image: 이미지
    ///   - imageTint: 이미지 강조 색상
    ///   - title: 타이틀 텍스트
    ///   - titleColor: 타이틀 색상
    ///   - titleFontStyle: 타이틀의 폰트 스타일
    ///   - buttonTitle: 버튼 타이틀 텍스트
    ///   - buttonTitleFontStyle: 버튼 타이틀의 폰트 스타일
    ///   - buttonTint: 버튼 강조 색상
    ///   - viewConfig: ToastView 설정값
    ///   - config: Toast 설정값
    /// - Returns: Observable
    @discardableResult
    func show(
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
    
    /// 정해진 Style의 Toast를 생성합니다.
    /// - Parameters:
    ///   - style: 스타일
    ///   - config: Toast 설정값
    func show(
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

/// BBToast를 조금 더 Rx스럽게 사용하도록 도와주는 서비스입니다.
public class BBToastService: BaseService, BBToastServiceType { }


