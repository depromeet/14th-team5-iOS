//
//  AccountSignInHelperType.swift
//  Domain
//
//  Created by geonhui Yu on 12/6/23.
//

import UIKit
import RxSwift

public protocol AccountSignInHelperType: AnyObject {
    var signInState: Observable<String> { get }
    func signIn(on window: UIWindow)
    func signOut()
}
