//
//  BBEqualizerConfig.swift
//  Core
//
//  Created by 김도현 on 1/21/25.
//

import UIKit

struct BBEqualizerConfig {
    let waveColor: UIColor
    let waveWidth: CGFloat
    let waveHeight: CGFloat
    let dotColor: UIColor
    let dotWidth: CGFloat
    let dotHeight: CGFloat
    
    init(
        waveColor: UIColor,
        waveWidth: CGFloat = 2.0,
        waveHeight: CGFloat = 3.0,
        dotColor: UIColor,
        dotWidth: CGFloat = 2.0,
        dotHeight: CGFloat = 2.0
    ) {
        self.waveColor = waveColor
        self.waveWidth = waveWidth
        self.waveHeight = waveHeight
        self.dotColor = dotColor
        self.dotWidth = dotWidth
        self.dotHeight = dotHeight
    }
}

public enum BBEqualizerState {
    case play
    case stop
    
    
    var config: BBEqualizerConfig {
        switch self {
        case .play:
            return .init(
                waveColor: .mainYellow,
                waveWidth: 2.0,
                dotColor: .gray500
            )
        case .stop:
            return .init(
                waveColor: .mainYellow,
                dotColor: .gray500,
                dotWidth: 2.0,
                dotHeight: 2.0
            )
        }
    }
}
