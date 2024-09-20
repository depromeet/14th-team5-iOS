//
//  BBAlertViewConfiguration.swift
//  BBAlert
//
//  Created by 김건우 on 8/7/24.
//

import UIKit

// MARK: - Typealias

/// 버튼을 어느 방향으로 배치할 지 설정할 수 있습니다.
public typealias BBAlertButtonAxis = NSLayoutConstraint.Axis


/// BBAlert 뷰의 높이, 너비, 배경 색상과 둥글기 반경, 버튼 축 방향과 높이를 설정할 수 있습니다.
///
/// - Note: 애니메이션, 오버랩 허용 유무 등 BBAlert에 대한 설정은 BBAlertConfiguration에서 하세요.
/// - Authors: 김소월
public struct BBAlertViewConfiguration {
    
    // MARK: - Properties
    
    /// BBAlert 뷰의 최소 너비입니다.
    public let minWidth: CGFloat
    
    /// BBAlert 뷰의 최소 높이입니다.
    public let minHeight: CGFloat
    
    /// BBAlert 뷰의 타이틀의 라인 수를 설정합니다.
    public let titleNumberOfLines: Int
    
    /// BBAlert 뷰의 서브 타이틀의 라인 수를 설정합니다.
    public let subtitleNumberOfLines: Int
    
    /// BBAlert 뷰의 배경 색상을 설정합니다.
    ///
    /// - Note: ``BBAlertConfiguration``의 `background` 프로퍼티는 Alert 뒤의 배경 색상을 지정합니다.
    public let backgroundColor: UIColor?
    
    /// BBAlert 뷰의 둥글기 반경을 설정합니다.
    public let cornerRadius: CGFloat?
    
    /// BBAlert 뷰의 버튼 배치 방향을 설정합니다.
    public let buttonAxis: BBAlertButtonAxis
    
    /// BBAlert 뷰의 버튼 높이를 설정합니다. 모든 버튼의 높이에 적용됩니다.
    public let buttonHieght: CGFloat
    
    
    // MARK: - Intializer
    
    
    /// BBAlert 뷰의 높이, 너비, 배경 색상과 둥글기 반경, 버튼 축 방향과 높이를 설정할 수 있습니다.
    /// - Parameters:
    ///   - minWidth: BBAlert 뷰의 최소 너비
    ///   - minHeight: BBAlert 뷰의 최소 높이
    ///   - titleNumberOfLines: BBAlert 뷰의 타이틀의 라인 수
    ///   - subtitleNumberOfLines: BBAlert 뷰의 서브 타이틀의 라인 수
    ///   - backgroundColor: BBAlert 뷰의 배경 색상
    ///   - cornerRadius: BBAlert 뷰의 둥글기 반경
    ///   - buttonAxis: BBAlert 뷰의 버튼 배치 방향
    ///   - buttonHeight: BBAlert 뷰의 버튼 높이
    public init(
        minWidth: CGFloat = 280,
        minHeight: CGFloat = 384,
        titleNumberOfLines: Int = 1,
        subtitleNumberOfLines: Int = 10,
        backgroundColor: UIColor? = .gray900,
        cornerRadius: CGFloat? = nil,
        buttonAxis: BBAlertButtonAxis = .vertical,
        buttonHeight: CGFloat = 44
    ) {
        self.minWidth = minWidth
        self.minHeight = minHeight
        self.titleNumberOfLines = titleNumberOfLines
        self.subtitleNumberOfLines = subtitleNumberOfLines
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.buttonAxis = buttonAxis
        self.buttonHieght = buttonHeight
    }
    
}
