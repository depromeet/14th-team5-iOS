//
//  BaseGlobalState.swift
//  Core
//
//  Created by 김건우 on 12/9/23.
//

import ReactorKit

public class BaseService {
    unowned let provider: ServiceProviderProtocol
    
    init(provider: ServiceProviderProtocol) {
        self.provider = provider
    }
}
