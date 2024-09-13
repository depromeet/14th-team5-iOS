//
//  ManagementTableDelegate.swift
//  App
//
//  Created by 김건우 on 9/10/24.
//

import UIKit

@objc public protocol ManagementTableDelegate {
    
    @objc optional func table(_ refreshControl: UIRefreshControl, didPullDownRefreshControl: UIRefreshControl.Event)
    
}
