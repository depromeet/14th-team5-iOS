//
//  CameraViewReactor.swift
//  App
//
//  Created by Kim dohyun on 12/6/23.
//

import Foundation

import ReactorKit


public final class CameraViewReactor: Reactor {
    
    public var initialState: State
    private var cameraRepository: CameraViewImpl
    
    public enum Action {
        case didTapTakeButton
    }
    
    public struct State {
        //TODO: 문서 확인 후 변경 될 수 있음
        var isFlashMode: Bool
        var isSwitchPosition: Bool
    }
    
    init(cameraRepository: CameraViewRepository) {
        self.cameraRepository = cameraRepository
        self.initialState = State(
            isFlashMode: false,
            isSwitchPosition: false
        )
    }
    
    
    
}
