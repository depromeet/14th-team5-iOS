//
//  UIPageViewController+Ext.swift
//  Core
//
//  Created by geonhui Yu on 12/24/23.
//

import UIKit

extension UIPageViewController {
    public var isPagingEnabled: Bool {
        get {
           var isEnabled: Bool = true
           for view in view.subviews {
               if let subView = view as? UIScrollView {
                   isEnabled = subView.isScrollEnabled
               }
           }
           return isEnabled
       }
       set {
           for view in view.subviews {
               if let subView = view as? UIScrollView {
                   subView.isScrollEnabled = newValue
               }
           }
       }
   }
}

