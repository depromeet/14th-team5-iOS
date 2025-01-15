//
//  SharingDelegate.swift
//  App
//
//  Created by 김건우 on 9/1/24.
//

import UIKit

@objc public protocol SharingContainerDlegate {
    
    @objc optional func sharing(_ button: UIButton, didTapSharingButton event: UIButton.Event)
    
}
