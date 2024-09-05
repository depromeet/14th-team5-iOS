//
//  LottieType.swift
//  Core
//
//  Created by geonhui Yu on 1/29/24.
//

import Foundation
import DesignSystem

@available(*, deprecated)
public enum LottieType: Equatable {
    static let keyLoading = "loading"
    static let keyfire = "fire"
    
    case loading
    case fire
    
    public var key: String {
        switch self {
        case .loading: return LottieType.keyLoading
        case .fire: return LottieType.keyfire
        }
    }
}
