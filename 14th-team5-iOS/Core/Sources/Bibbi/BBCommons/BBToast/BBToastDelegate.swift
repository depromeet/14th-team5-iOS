//
//  ToastDelegate.swift
//  BBToast
//
//  Created by 김건우 on 7/8/24.
//

import Foundation

public protocol BBToastDelegate: AnyObject {
    
    func willShowToast(_ toast: BBToast)
    func didShowToast(_ toast: BBToast)
    func willCloseToast(_ toast: BBToast)
    func didCloseToast(_ toast: BBToast)
    
    func didTapToastButton(_ toast: BBToast)
    
}

public extension BBToastDelegate {
    
    func willShowToast(_ toast: BBToast) { }
    func didShowToast(_ toast: BBToast) { }
    func willCloseToast(_ toast: BBToast) { }
    func didCloseToast(_ toast: BBToast) { }
    
    func didTapToastButton(_ toast: BBToast) { }
    
}
