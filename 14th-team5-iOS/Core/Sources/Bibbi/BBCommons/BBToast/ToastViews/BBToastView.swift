//
//  ToastView.swift
//  BBToast
//
//  Created by 김건우 on 7/4/24.
//

import UIKit

public protocol BBToastView: UIView {
    func createView(for toast: BBToast)
}
