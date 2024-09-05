//
//  BBProgressHUDDelegate.swift
//  BBProgressHUD
//
//  Created by 김건우 on 8/16/24.
//

import Foundation

public protocol BBProgressHUDDelegate {
    
    func willShowProgressHUD(_ progress: BBProgressHUD)
    func didShowProgressHUD(_ progress: BBProgressHUD)
    func willHideProgressHUD(_ progress: BBProgressHUD)
    func didHideProgressHUD(_ progess: BBProgressHUD)
    
}

extension BBProgressHUDDelegate {
    
    func willShowProgressHUD(_ progress: BBProgressHUD) { }
    func didShowProgressHUD(_ progress: BBProgressHUD) { }
    func willHideProgressHUD(_ progress: BBProgressHUD) { }
    func didHideProgressHUd(_ progress: BBProgressHUD) { }
    
}
