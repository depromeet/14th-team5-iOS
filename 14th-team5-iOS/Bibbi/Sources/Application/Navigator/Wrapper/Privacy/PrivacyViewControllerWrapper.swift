//
//  PrivacyViewControllerWrapper.swift
//  App
//
//  Created by Kim dohyun on 9/11/24.
//

import Core
import Foundation
import MacrosInterface

@Wrapper<PrivacyViewReactor, PrivacyViewController>
final class PrivacyViewControllerWrapper {
    
    private let memberId: String
    
    public init(memberId: String) {
        self.memberId = memberId
    }
    
    func makeReactor() -> PrivacyViewReactor {
        return PrivacyViewReactor(memberId: memberId)
    }
}

