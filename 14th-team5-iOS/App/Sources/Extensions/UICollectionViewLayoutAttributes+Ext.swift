//
//  UICollectionViewLayoutAttributes+Ext.swift
//  App
//
//  Created by 마경미 on 12.12.23.
//

import Foundation

extension UICollectionViewLayoutAttributes {
    func rightAlignFrameOnWidth(_ width: CGFloat,  with sectionInset: UIEdgeInsets){
        var frame = self.frame
        frame.origin.x = width - frame.size.width - sectionInset.left
        self.frame = frame
    }
}
