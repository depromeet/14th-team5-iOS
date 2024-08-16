//
//  BBLottieView.swift
//  Core
//
//  Created by 김건우 on 8/16/24.
//

import UIKit

import Lottie

public class BBLottieView: LottieAnimationView {
    
    // MARK: - Intializer
    
    public init(
        of kind: BBLottieKind
    ) {
        super.init(frame: .zero)
        animation = LottieAnimation.named(kind.name)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helpers
    
    public func startAnimating(completion: LottieCompletionBlock? = nil) {
        play(completion: completion)
    }
    
    /// Plays the animation from a start frame to an end frame in the animation’s framerate.
    public func startAnimating(
        fromFrame startFrame: AnimationFrameTime? = nil,
        toFrame endFrame: AnimationFrameTime,
        loopMode: LottieLoopMode? = .loop,
        completion: LottieCompletionBlock? = nil
    ) {
        play(
            fromFrame: startFrame,
            toFrame: endFrame,
            loopMode: loopMode,
            completion: completion
        )
    }
    
    /// Plays the animation from a progress (0-1) to a progress (0-1).
    public func startAnimating(
        fromProgress startTime: AnimationProgressTime? = nil,
        toProgress endTime: AnimationProgressTime = 1,
        loopMode: LottieLoopMode? = .loop,
        completion: LottieCompletionBlock? = nil
    ) {
        play(
            fromProgress: startTime,
            toProgress: endTime,
            loopMode: loopMode,
            completion: completion
        )
    }
    
    /// Pauses the animation in its current state.
    /// The completion closure will be called with false
    public func pauseAnimating() {
        pause()
    }
    
    /// Stops the animation and resets the view to its start frame.
    /// The completion closure will be called with false
    public func stopAnimating() {
        stop()
    }
    
}
