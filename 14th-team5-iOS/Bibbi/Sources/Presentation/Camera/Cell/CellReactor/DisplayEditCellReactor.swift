//
//  DisplayEditCellReactor.swift
//  App
//
//  Created by Kim dohyun on 12/13/23.
//

import UIKit

import Core
import DesignSystem
import ReactorKit



public final class DisplayEditCellReactor: Reactor {
    public typealias Action = NoAction
    
    public var initialState: State
    
    public struct State {
        var title: String
        var radius: CGFloat
        var font: BBFontStyle
    }
    
    
    init(title: String, radius: CGFloat, font: BBFontStyle) {
        self.initialState = State(title: title, radius: radius, font: font)
    }
    
    
}
