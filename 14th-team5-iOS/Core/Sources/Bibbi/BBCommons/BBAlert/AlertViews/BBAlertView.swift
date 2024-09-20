//
//  BBAlertView.swift
//  BBAlert
//
//  Created by 김건우 on 8/6/24.
//

import UIKit

public protocol BBAlertView: UIView {
    func createView(for alert: BBAlert, actions: [BBAlertAction])
}
