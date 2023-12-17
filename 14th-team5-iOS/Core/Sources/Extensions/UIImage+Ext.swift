//
//  UIImage+Ext.swift
//  App
//
//  Created by Kim dohyun on 12/7/23.
//

import UIKit

extension UIImage {
    public func combinedTextWithBackground(target text: String, size: CGSize, attributedString: [NSAttributedString.Key : Any]) -> UIImage {
        let renderImage: UIGraphicsImageRenderer = UIGraphicsImageRenderer(size: size)
        let targetText: NSString = (text as NSString)
        let targetTextSize: CGSize = targetText.size(withAttributes: attributedString)
        let targetRect: CGRect = CGRect(x: (size.width - targetTextSize.width) / 2, y: (size.height - targetTextSize.height) - 10, width: 100, height: 100)
        let originalImage: UIImage = renderImage.image { _ in
            draw(in: CGRect(origin: .zero, size: size))
            targetText.size(withAttributes: attributedString)
            targetText.draw(in: targetRect, withAttributes: attributedString)
        }
        return originalImage
    }
    
    public func combinedWithAlpha(with alpha: CGFloat, blendMode: CGBlendMode) -> UIImage {
        let renderImage: UIGraphicsImageRenderer = UIGraphicsImageRenderer(size: size)
        
        let originalImage: UIImage = renderImage.image { _ in
            draw(at: .zero, blendMode: blendMode, alpha: alpha)
        }
        
        return originalImage
    }
}
