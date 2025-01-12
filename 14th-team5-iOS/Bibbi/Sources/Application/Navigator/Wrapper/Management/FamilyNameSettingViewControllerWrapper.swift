//
//  FamilyNameSettingViewControllerWrapper.swift
//  App
//
//  Created by Kim dohyun on 7/23/24.
//

import Core
import Foundation
import MacrosInterface

@Wrapper<FamilyNameSettingViewReactor, FamilyNameSettingViewController>
final class FamilyNameSettingViewControllerWrapper {
  
    func makeReactor() -> FamilyNameSettingViewReactor {
        return FamilyNameSettingViewReactor()
    }
    
}
