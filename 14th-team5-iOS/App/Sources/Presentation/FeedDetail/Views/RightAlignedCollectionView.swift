//
//  RightAlignedCollectionView.swift
//  App
//
//  Created by 마경미 on 12.12.23.
//

import UIKit

final class UICollectionViewRightAlignedLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var attributesCopy: [UICollectionViewLayoutAttributes] = []
        if let attributes = super.layoutAttributesForElements(in: rect) {
            attributes.forEach({ attributesCopy.append($0.copy() as! UICollectionViewLayoutAttributes) })
        }
        
        for attributes in attributesCopy {
            if attributes.representedElementKind == nil {
                let indexpath = attributes.indexPath
                if let attr = layoutAttributesForItem(at: indexpath) {
                    attributes.frame = attr.frame
                }
            }
        }
        return attributesCopy

    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        if let currentItemAttributes = super.layoutAttributesForItem(at: indexPath as IndexPath)?.copy() as? UICollectionViewLayoutAttributes {
            
            let sectionInset = self.evaluatedSectionInsetForItem(at: indexPath.section)
            let layoutWidth = self.collectionView!.frame.width - sectionInset.left - sectionInset.right

            let isFirstItemInSection = indexPath.item == 0
            
            if (isFirstItemInSection) {
                currentItemAttributes.rightAlignFrameOnWidth(self.collectionView!.frame.size.width, with: sectionInset)
                return currentItemAttributes
            }
            
            let previousIndexPath = IndexPath(row: indexPath.item - 1, section: indexPath.section)
            
            let previousFrame = layoutAttributesForItem(at: previousIndexPath)?.frame ?? CGRect.zero
            let currentFrame = currentItemAttributes.frame
            let strecthedCurrentFrame = CGRect(x: sectionInset.right, y: currentFrame.origin.y, width: layoutWidth, height: currentFrame.size.height)


            let isFirstItemInRow = !previousFrame.intersects(strecthedCurrentFrame)
            
            if (isFirstItemInRow) {

                currentItemAttributes.rightAlignFrameOnWidth(self.collectionView!.frame.size.width, with: sectionInset)
                return currentItemAttributes
            }
            
            let previousFrameLeftPoint = previousFrame.origin.x;
            var frame = currentItemAttributes.frame
            frame.origin.x = previousFrameLeftPoint - evaluatedMinimumInteritemSpacing(at: indexPath.section) - frame.size.width
            currentItemAttributes.frame = frame
            return currentItemAttributes
            
        }
        return nil
    }
    
    func evaluatedMinimumInteritemSpacing(at sectionIndex:Int) -> CGFloat {
        if let delegate = self.collectionView?.delegate as? UICollectionViewDelegateFlowLayout {
            let inteitemSpacing = delegate.collectionView?(self.collectionView!, layout: self, minimumInteritemSpacingForSectionAt: sectionIndex)
            if let inteitemSpacing = inteitemSpacing {
                return inteitemSpacing
            }
        }
        return self.minimumInteritemSpacing
        
    }
    
    func evaluatedSectionInsetForItem(at index: Int) ->UIEdgeInsets {
        if let delegate = self.collectionView?.delegate as? UICollectionViewDelegateFlowLayout {
            let insetForSection = delegate.collectionView?(self.collectionView!, layout: self, insetForSectionAt: index)
            if let insetForSectionAt = insetForSection {
                return insetForSectionAt
            }
        }
        return self.sectionInset
    }
}
