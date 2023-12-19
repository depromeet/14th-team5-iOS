//
//  UICollectionViewLayoutAttributes+Ext.swift
//  App
//
//  Created by 마경미 on 12.12.23.
//

import UIKit

extension UICollectionViewLayoutAttributes {
    func rightAlignFrameOnWidth(_ width: CGFloat,  with sectionInset: UIEdgeInsets) {
        self.frame.origin.x = width - self.frame.size.width - sectionInset.left
    }
}
