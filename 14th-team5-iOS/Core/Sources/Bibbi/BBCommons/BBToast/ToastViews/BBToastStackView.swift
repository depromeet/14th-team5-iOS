//
//  BBToastSubView.swift
//  Core
//
//  Created by 김건우 on 8/5/24.
//

import UIKit

public protocol BBToastStackView: UIStackView {
    var toast: BBToast? { get set }
}
