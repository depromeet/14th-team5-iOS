//
//  MainFamilyViewControllerWrapper.swift
//  App
//
//  Created by 마경미 on 17.06.24.
//

import Core
import Foundation
import MacrosInterface

@Wrapper<MainFamilyViewReactor, MainFamilyViewController>
final class MainFamilyViewControllerWrapper {
  
    func makeReactor() -> R {
        return MainFamilyViewReactor()
    }

}
