//
//  BaseGlobalState.swift
//  Core
//
//  Created by 김건우 on 12/9/23.
//

import ReactorKit

public class BaseGlobalState {
    unowned let provider: GlobalStateProviderProtocol
    
    init(provider: GlobalStateProviderProtocol) {
        self.provider = provider
    }
}
