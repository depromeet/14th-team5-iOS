//
//  AccountRepository.swift
//  Data
//
//  Created by geonhui Yu on 12/18/23.
//

import UIKit
import Domain

import ReactorKit
import RxCocoa
import RxSwift

public protocol AccountImpl: AnyObject {
    var disposeBag: DisposeBag { get }
    
    func kakaoLogin(with snsType: SNS, vc: UIViewController)
}

public final class AccountRepository: AccountImpl {
    
    let signInHelper = AccountSignInHelper()
    
    public func kakaoLogin(with snsType: SNS, vc: UIViewController) {
        return signInHelper.trySignInWith(sns: snsType, window: vc.view.window)
    }
    

    public var disposeBag: DisposeBag = DisposeBag()
    
    public init() {}
}
