//
//  LeftAlignedFlowLayout.swift
//  App
//
//  Created by 마경미 on 31.03.24.
//

import UIKit

class RightAlignedFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }

        var maxY: CGFloat = 0
        var margin: CGFloat = 8
        let width: CGFloat = (collectionViewContentSize.width - (13 * 2) - (5 * 6)) / 6

        for attribute in attributes {
            if maxY < attribute.frame.origin.y {
                maxY = attribute.frame.origin.y
                margin = 8
            }
            
            margin += width + minimumInteritemSpacing
            attribute.frame.origin.x = collectionViewContentSize.width - margin
            attribute.frame.size.width = width
        }
        
    
        return attributes
    }
}
