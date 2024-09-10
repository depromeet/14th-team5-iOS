//
//  ManagementTableViewDelegateProxy.swift
//  App
//
//  Created by 김건우 on 9/1/24.
//

import UIKit

@objc public protocol ManagementTableDelegate {
    
    @objc optional func table(_ table: UITableView, didSelect: Int)
    
}
