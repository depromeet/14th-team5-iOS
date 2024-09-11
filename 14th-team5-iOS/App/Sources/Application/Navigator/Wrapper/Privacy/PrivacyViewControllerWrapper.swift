//
//  PrivacyViewControllerWrapper.swift
//  App
//
//  Created by Kim dohyun on 9/11/24.
//

import Core
import Foundation


final class PrivacyViewControllerWrapper: BaseWrapper {
    typealias R = PrivacyViewReactor
    typealias V = PrivacyViewController
    
    private let memberId: String
    
    public init(memberId: String) {
        self.memberId = memberId
    }
    
    var reactor: PrivacyViewReactor {
        return makeReactor()
    }
    
    var viewController: PrivacyViewController {
        return makeViewController()
    }
    
    func makeViewController() -> PrivacyViewController {
        PrivacyViewController(reactor: makeReactor())
    }
    
    func makeReactor() -> PrivacyViewReactor {
        return PrivacyViewReactor(memberId: memberId)
    }
}

