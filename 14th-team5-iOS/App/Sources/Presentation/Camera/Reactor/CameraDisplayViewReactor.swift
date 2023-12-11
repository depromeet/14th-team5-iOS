//
//  CameraDisplayViewReactor.swift
//  App
//
//  Created by Kim dohyun on 12/11/23.
//

import Foundation

import Data
import ReactorKit



public final class CameraDisplayViewReactor: Reactor {

    public var initialState: State
    private var cameraDisplayRepository: CameraDisplayImpl
    
    public typealias Action = NoAction
    
    public struct State {
        
    }
    
    init(cameraDisplayRepository: CameraDisplayImpl) {
        self.cameraDisplayRepository = cameraDisplayRepository
        self.initialState = State()
    }
    
    
    
}
