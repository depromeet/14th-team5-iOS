//
//  BBEqualizerView.swift
//  Core
//
//  Created by 김도현 on 1/17/25.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa


struct BBEqualizerConfig {
    let waveColor: UIColor?
    let waveWidth: CGFloat?
    let dotColor: UIColor?
    let dotWidth: CGFloat?
    let dotHeight: CGFloat?
    
    init(
        waveColor: UIColor? = nil,
        waveWidth: CGFloat? = nil,
        dotColor: UIColor? = nil,
        dotWidth: CGFloat? = nil,
        dotHeight: CGFloat? = nil
    ) {
        self.waveColor = waveColor
        self.waveWidth = waveWidth
        self.dotColor = dotColor
        self.dotWidth = dotWidth
        self.dotHeight = dotHeight
    }
}


@objc public protocol BBEqualizerViewDelegate: AnyObject {
    @objc optional func equalizerView(_ equalizerView: BBEqualizerView, didUpdateDecibel decibel: [CGFloat]) -> [CGFloat]
}

public final class BBEqualizerView: UIView {
    public var state: BBEqualizerState = .stop {
        didSet { setNeedsDisplay() }
    }
    public weak var delegate: BBEqualizerViewDelegate?
    private(set) var displayLink: CADisplayLink?
    private let timerLabel: BBLabel = BBLabel(.body1Regular)
    
    
    
    public init(state: BBEqualizerState) {
        self.state = state
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.clear(rect)
        
        
    }
    
    private func setupUI() {
        addSubviews(timerLabel)
    }
    
    private func setupAutoLayout() {
        
    }
    
    private func setupAttributes() {
        timerLabel.do {
            $0.textColor = .gray500
            $0.text = "0:00"
        }
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
                waveWidth: 2.0
            )
        case .stop:
            return .init(
                dotColor: .mainYellow,
                dotWidth: 2.0,
                dotHeight: 2.0
            )
        }
    }
}




public class RxEqualizerViewDelegateProxy: DelegateProxy<BBEqualizerView, BBEqualizerViewDelegate>, DelegateProxyType, BBEqualizerViewDelegate {
    public static func currentDelegate(for object: BBEqualizerView) -> (any BBEqualizerViewDelegate)? {
        return object.delegate
    }
    
    public static func setCurrentDelegate(_ delegate: (any BBEqualizerViewDelegate)?, to object: BBEqualizerView) {
        object.delegate = delegate
    }
    
    static public func registerKnownImplementations() {
        self.register {
            RxEqualizerViewDelegateProxy(
                parentObject: $0,
                delegateProxy: self
            )
        }
    }
}



extension Reactive where Base: BBEqualizerView {
    
    public var delegate: DelegateProxy<BBEqualizerView, BBEqualizerViewDelegate> {
        return RxEqualizerViewDelegateProxy.proxy(for: self.base)
    }
    
    public var didUpdateDecibel: Observable<[CGFloat]> {
        let source = delegate.methodInvoked(#selector(BBEqualizerViewDelegate.equalizerView(_:didUpdateDecibel:)))
            .compactMap { $0.first as? [CGFloat]}
        
        return source
    }
}
