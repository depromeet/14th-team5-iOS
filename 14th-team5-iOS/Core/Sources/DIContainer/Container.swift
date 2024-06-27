//
//  Container.swift
//  DIContainer
//
//  Created by 김건우 on 6/3/24.
//

import Foundation


// MARK: - Container

public class Container: Injectable {
    
    public static var standard = Container()
    
    public var dependencies: [AnyHashable : Any] = [:]
    
    required public init() { }
    
}
