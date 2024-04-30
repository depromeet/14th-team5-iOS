//
//  MainCameraDIContainer.swift
//  App
//
//  Created by 마경미 on 30.04.24.
//

import Foundation

import Domain

final class MainCameraDIContainer {
    func makeView() -> MainCameraButtonView {
        return MainCameraButtonView(reactor: makeReactor())
    }
    
    func makeReactor() -> MainCameraReactor {
        return MainCameraReactor()
    }
}
