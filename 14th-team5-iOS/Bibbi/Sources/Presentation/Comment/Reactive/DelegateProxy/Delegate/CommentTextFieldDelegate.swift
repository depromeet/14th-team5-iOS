//
//  CommentTextFieldDelegate.swift
//  App
//
//  Created by 김건우 on 9/12/24.
//

import UIKit

@objc public protocol CommentTextFieldDelegate: AnyObject {
    @objc optional func didTapConfirmButton(_ button: UIButton, text: String?, event: UITextField.Event)
    @objc optional func didTapDoneButton(text: String?)
}
