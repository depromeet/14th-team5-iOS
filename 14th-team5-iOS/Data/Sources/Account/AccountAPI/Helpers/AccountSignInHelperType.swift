//
//  AccountSignInHelperType.swift
//  Domain
//
//  Created by geonhui Yu on 12/6/23.
//

import Core
import Domain
import UIKit

import RxSwift

public protocol AccountSignInHelperType: AnyObject {
    var signInState: Observable<AccountSignInStateInfo> { get }  // ?
    
    func signIn(on window: UIWindow) -> Observable<APIResult>
    func signOut()
}
