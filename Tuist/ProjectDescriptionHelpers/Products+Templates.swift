//
//  Products+Templates.swift
//  ProjectDescriptionHelpers
//
//  Created by Kim dohyun on 2023/11/14.
//

import Foundation
import ProjectDescriptionHelpers

public enum ProductState {
    case `static`, `dynamic`
}

public enum ProductsType: Equatable {
    var isLibrary: Bool {
        return (self == .library(.static) || self == .library(.dynamic))
    }
    
    var isFramework: Bool {
        return (self == .framework(.static) || self == .framework(.dynamic))
    }

    
    case library(ProductState)
    case framework(ProductState)
    case app
    case unitTests
    case uiTests
    
}
