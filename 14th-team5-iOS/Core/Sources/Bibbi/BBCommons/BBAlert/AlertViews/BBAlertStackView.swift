//
//  BBAlertStackView.swift
//  BBAlert
//
//  Created by 김건우 on 8/7/24.
//

import UIKit

public protocol BBAlertStackView: UIStackView {
    var alert: BBAlert? { get set }
}
