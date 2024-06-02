//
//  AccountSignInHelperType.swift
//  Domain
//
//  Created by geonhui Yu on 12/6/23.
//

import UIKit
import Domain
import Core

import RxSwift

public protocol AccountSignInHelperType: AnyObject {
    var signInState: Observable<AccountSignInStateInfo> { get }
    func signIn(on window: UIWindow) -> Observable<APIResult>
    func signOut()
}
