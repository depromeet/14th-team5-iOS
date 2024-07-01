//
//  BaseContainer.swift
//  Core
//
//  Created by 김건우 on 6/14/24.
//

import Foundation

public protocol BaseContainer {
    
    func registerDependencies()
    
}

public extension BaseContainer {
    
    var container: Container {
        Container.standard
    }
    
}
