//
//  BBNavigationBarDelegate.swift
//  Core
//
//  Created by 김건우 on 8/11/24.
//

import UIKit

@objc public protocol BBNavigationBarDelegate {
    @objc optional func navigationBar(_ button: UIButton, didTapRightBarButton event: UIControl.Event)
    @objc optional func navigationBar(_ button: UIButton, didTapLeftBarButton event: UIControl.Event)
}
