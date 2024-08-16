//
//  BBLottieViewType.swift
//  Core
//
//  Created by 김건우 on 8/16/24.
//

import UIKit

// MARK: - Typealias

public typealias BBLottieViewKind = BBLottieView.Kind


// MARK: - Extensions

extension BBLottieView {
    
    public enum `Kind`: String {
        case fire
        case airplane
        
        var name: String {
            switch self {
            case .fire: return "fire"
            case .airplane: return "loading"
            }
        }
    }
    
}
