//
//  CameraViewControllerWrapper.swift
//  App
//
//  Created by Kim dohyun on 6/19/24.
//

import Core
import Domain

import Foundation

final class CameraViewControllerWrapper: BaseWrapper {

    typealias R = CameraViewReactor
    typealias V = CameraViewController
    
    var reactor: CameraViewReactor {
        return makeReactor()
    }
    var viewController: CameraViewController {
        return makeViewController()
    }
    
    private let cameraType: UploadLocation
    private let memberId: String
    private let realEmojiType: Emojis
    
    public init(
        cameraType: UploadLocation,
        memberId: String = "",
        realEmojiType: Emojis = .emoji(forIndex: 1)
    ) {
        self.cameraType = cameraType
        self.memberId = memberId
        self.realEmojiType = realEmojiType
    }
    
    
    func makeReactor() -> CameraViewReactor {
        return CameraViewReactor(
            cameraType: cameraType,
            memberId: memberId,
            emojiType: realEmojiType
        )
    }
    
    func makeViewController() -> CameraViewController {
        return CameraViewController(reactor: reactor)
    }
    
}
