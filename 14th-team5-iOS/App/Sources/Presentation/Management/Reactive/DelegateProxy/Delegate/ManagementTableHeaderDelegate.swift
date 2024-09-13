//
//  ManagementTableViewDelegateProxy.swift
//  App
//
//  Created by 김건우 on 9/1/24.
//

import UIKit

@objc public protocol ManagementTableHeaderDelegate {
    
    @objc optional func tableHeader(_ button: UIButton, didTapFamilyNameEidtButton: UIButton.Event)
    
}
