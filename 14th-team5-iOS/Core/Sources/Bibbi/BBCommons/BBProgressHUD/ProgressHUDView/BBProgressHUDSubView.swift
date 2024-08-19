//
//  BBProgressHUDStackView.swift
//  BBProgressHUD
//
//  Created by 김건우 on 8/16/24.
//

import UIKit

public protocol BBProgressHUDStackView: UIStackView {
    var progressHud: BBProgressHUD? { get set }
}
