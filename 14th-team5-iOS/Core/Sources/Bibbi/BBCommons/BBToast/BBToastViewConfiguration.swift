//
//  ToastViewConfiguration.swift
//  BBToast
//
//  Created by 김건우 on 7/8/24.
//

import UIKit

public struct BBToastViewConfiguration {
    
    // MARK: - Properties
    
    /// BBToast 뷰의 최소 너비입니다.
    public let minWidth: CGFloat
    
    /// BBToast 뷰의 최소 높이입니다.
    public let minHeight: CGFloat
    
    /// BBToast 뷰의 버튼의 최소 너비입니다.
    public let minButtonWidth: CGFloat
    
    /// BBToast 뷰의 버턴의 최소 높이입니다.
    public let minButtonHeight: CGFloat
    
    /// BBToast 뷰의 배경 색상을 설정합니다.
    ///
    /// - Note: ``BBToastConfiguration``의 `background` 프로퍼티는 Toast 뒤의 배경 색상을 지정합니다.
    public let backgroundColor: UIColor
    
    /// BBToast 뷰의 타이틀의 라인 수를 설정합니다.
    public let titleNumberOfLines: Int
    
    /// BBToast 뷰의 서브 타이틀의 라인 수를 설정합니다.
    public let subtitleNumberOfLines: Int
    
    /// BBToast 뷰의 둥글기 반경을 설정합니다.
    public let cornerRadius: CGFloat?
    
    
    // MARK: - Intializer
    
    /// BBToast 뷰의 높이, 너비, 배경 색상과 둥글기 반경을 설정할 수 있습니다.
    /// - Parameters:
    ///   - minWidth: BBToast 뷰의 최소 너비
    ///   - minHeight: BBToast 뷰의 최소 높이
    ///   - minButtonWidth: BBToast 뷰의 버튼의 최소 너비
    ///   - minButtonHeight: BBToast 뷰의 버튼의 최소 높이
    ///   - backgroundColor: BBToast 뷰의 배경 색상
    ///   - titleNumberOfLines: BBToast 뷰의 타이틀의 라인 수
    ///   - subtitleNumberOfLines: BBToast 뷰의 서브 타이틀의 라인 수
    ///   - cornerRadius: BBToast 뷰의 둥글기 반경
    public init(
        minWidth: CGFloat = 300,
        minHeight: CGFloat = 56,
        minButtonWidth: CGFloat = 30,
        minButtonHeight: CGFloat = 24,
        backgroundColor: UIColor = .gray900,
        titleNumberOfLines: Int = 1,
        subtitleNumberOfLines: Int = 1,
        cornerRadius: CGFloat? = nil
    ) {
        self.minWidth = minWidth
        self.minHeight = minHeight
        self.minButtonWidth = minButtonWidth
        self.minButtonHeight = minButtonHeight
        self.backgroundColor = backgroundColor
        self.titleNumberOfLines = titleNumberOfLines
        self.subtitleNumberOfLines = subtitleNumberOfLines
        self.cornerRadius = cornerRadius
    }
    
}
