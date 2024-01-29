//
//  LottieType.swift
//  Core
//
//  Created by geonhui Yu on 1/29/24.
//

import Foundation
import DesignSystem

public enum LottieType: Equatable {
    static let keyLoading = "loading"
    static let keyfire = "fire"
    
    case loading
    case fire
    
    var key: String {
        switch self {
        case .loading: return LottieType.keyLoading
        case .fire: return LottieType.keyfire
        }
    }
}
