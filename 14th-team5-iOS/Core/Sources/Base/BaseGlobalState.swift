//
//  BaseGlobalState.swift
//  Core
//
//  Created by 김건우 on 12/9/23.
//

import ReactorKit

public class BaseGlobalState {
    unowned let provider: GlobalStateProviderType
    
    init(provider: GlobalStateProviderType) {
        self.provider = provider
    }
}
