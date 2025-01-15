//
//  Products+Templates.swift
//  ProjectDescriptionHelpers
//
//  Created by Kim dohyun on 2023/11/14.
//

import ProjectDescription

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
    
    var isApp: Bool {
        return (self == .bibbi)
    }
    
    var isExtensions: Bool {
        return (self == .appExtension)
    }
    
    case appExtension
    case library(ProductState)
    case framework(ProductState)
    case bibbi
    case unitTests
    case uiTests
    
}
