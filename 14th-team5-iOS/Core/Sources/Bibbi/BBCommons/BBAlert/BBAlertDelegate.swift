//
//  BBAlertDelegate.swift
//  BBAlert
//
//  Created by 김건우 on 8/9/24.
//

import Foundation

public protocol BBAlertDelegate: AnyObject {
    
    func willShowAlert(_ alert: BBAlert)
    func didShowAlert(_ alert: BBAlert)
    func willCloseAlert(_ alert: BBAlert)
    func didCloseAlert(_ alert: BBAlert)
    
    func didTapAlertButton(_ alert: BBAlert?, index: Int?, button: BBButton)
    
}

public extension BBAlertDelegate {
    
    func willShowAlert(_ alert: BBAlert) { }
    func didShowAlert(_ alert: BBAlert) { }
    func willCloseAlert(_ alert: BBAlert) { }
    func didCloseAlert(_ alert: BBAlert) { }
    
    func didTapAlertButton(_ alert: BBAlert?, index: Int?, button: BBButton) { }
    
}
