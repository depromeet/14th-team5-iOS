//
//  BBToolTipPosition.swift
//  Core
//
//  Created by Kim dohyun on 9/19/24.
//

import Foundation

/// BBToolTip에 Arrow Horizontal 위치를 설정하기 위한 Nested types입니다.
public enum BBToolTipHorizontalPosition: CGFloat {
    /// 왼쪽 가장자리에 위치하는 포지션입니다.
    case left = 0.0
    
    /// 왼쪽과 중앙 사이에 위치하는 포지션입니다.
    case midLeft = 0.25
    
    /// 중앙에 위치하는 포지션입니다.
    case center = 0.5
    
    /// 오른쪽과 중앙 사이에 위치하는 포지션입니다.
    case midRight = 0.75
    
    /// 오른쪽 가장자리에 위치하는 포지션입니다.
    case right = 1.0
}

/// BBToolTip에 Arrow Vertical 위지를 설정하기 위한 Nested types입니다.
public enum BBToolTipVerticalPosition {
    /// 상단에 배치하는 포지션입니다.
    case top
    
    /// 하단에 배치하는 포지션입니다.
    case bottom
}
