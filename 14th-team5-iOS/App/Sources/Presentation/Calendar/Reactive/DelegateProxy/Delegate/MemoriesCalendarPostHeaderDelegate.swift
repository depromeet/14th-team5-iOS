//
//  File.swift
//  App
//
//  Created by 김건우 on 10/18/24.
//

import UIKit

@objc protocol MemoriesCalendarPostHeaderDelegate: AnyObject {
    @objc optional func didTapProfileImageButton(_ button: UIButton, event: UIButton.Event)
}
