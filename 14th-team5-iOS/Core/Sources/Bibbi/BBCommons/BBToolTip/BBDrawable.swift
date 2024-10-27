//
//  BBDrawable.swift
//  Core
//
//  Created by Kim dohyun on 9/19/24.
//

import UIKit

/// **UIBezierPath**, ** CALayer**, **CGMutablePath**을  활용한 draw 메서드를 정의하는 Protocol입니다.
protocol BBDrawable {
    func drawToolTip(_ frame: CGRect, type: BBToolTipType, context: CGContext)
    func drawToolTipArrowShape(_ frame: CGRect, type: BBToolTipType, path: CGMutablePath)
    func drawToolTipBottomShape(_ frame: CGRect, toolTipType: BBToolTipType, cornerRadius: CGFloat, path: CGMutablePath)
    func drawToolTipTopShape(_ frame: CGRect, toolTipType: BBToolTipType, cornerRadius: CGFloat, path: CGMutablePath)
}

