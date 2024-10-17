//
//  UICollectionView+Ext.swift
//  Core
//
//  Created by 김건우 on 10/17/24.
//

import UIKit

public extension UICollectionView {
    
    /// 컬렉션 뷰를 특정 IndexPath로 스크롤합니다.
    /// - Parameters:
    ///   - indexPath: 스크롤하고자 하는 IndexPath입니다.
    ///   - scrollPostion: 특정 셀을 스크롤할 위치입니다. 기본값은 `centeredHorizontally`입니다.
    ///   - animated: 스크롤 시 애니메이션 여부입니다. 기본값은 `false`입니다.
    ///
    /// - Authors: 김소월
    func scroll(
        to indexPath: IndexPath,
        at scrollPostion: ScrollPosition = .centeredHorizontally,
        animated: Bool = false
    ) {
        self.scrollToItem(at: indexPath, at: scrollPostion, animated: animated)
    }
    
}
