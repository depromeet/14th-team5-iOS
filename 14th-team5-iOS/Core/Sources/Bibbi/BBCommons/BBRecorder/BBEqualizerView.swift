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


public final class BBEqualizerView: UIView {
    public var state: BBEqualizerState = .stop
    private(set) var displayLink: CADisplayLink?
    public let timerLabel: BBLabel = BBLabel(.body1Regular)
    private var lastUpdateTime: Date = Date()
    public var eqaulizerIndex: Int = 0
    public var equalizerLevels: [CGFloat] = [] {
        didSet {
            if state == .play {
                didUpdateEqaulizerLayout()
            } else {
                removeEqaulizerLayout()
            }
        }
    }
    
    public init(state: BBEqualizerState) {
        self.state = state
        super.init(frame: .zero)
        setupUI()
        setupAttributes()
        setupAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.clear(rect)
        let maxWidth = timerLabel.frame.minX
        let dotWidth = maxWidth / 30
        let waveHeight = state.config.waveHeight
        let dotHeight = state.config.dotHeight
        let midY = rect.midY

        context.setStrokeColor(state.config.waveColor.cgColor)
        context.setLineWidth(state.config.waveWidth)

        for index in 0 ..< eqaulizerIndex {
            let transformHeight = equalizerLevels.indices.contains(index)
                ? equalizerLevels[index] * waveHeight
                : waveHeight
            let pointX = CGFloat(index) * dotWidth
            let pointY = midY - (transformHeight / 2)
            context.move(to: CGPoint(x: pointX, y: pointY))
            context.addLine(to: CGPoint(x: pointX, y: pointY + transformHeight))
        }
        context.strokePath()

        context.setStrokeColor(state.config.dotColor.cgColor)
        context.setLineWidth(state.config.dotWidth)

        for index in eqaulizerIndex ..< 30 {
            let pointX = CGFloat(index) * dotWidth
            let pointY = midY - (dotHeight / 2)
            context.move(to: CGPoint(x: pointX, y: pointY))
            context.addLine(to: CGPoint(x: pointX, y: pointY + dotHeight))
        }
        context.strokePath()
    }
    
    private func setupUI() {
        addSubviews(timerLabel)
    }
    
    private func setupAutoLayout() {
        timerLabel.snp.makeConstraints {
            $0.width.equalTo(40)
            $0.height.equalTo(21)
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview()
        }
    }
    
    private func setupAttributes() {
        timerLabel.do {
            $0.textColor = .gray500
            $0.text = "0:00"
        }
    }
    
    private func didUpdateEqaulizerLayout() {
        guard displayLink == nil else { return }
        displayLink = CADisplayLink(target: self, selector: #selector(didUpdateEqaulizerLevel))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    private func removeEqaulizerLayout() {
        displayLink?.invalidate()
        displayLink = nil
        eqaulizerIndex = 0
    }
    
    
    @objc
    private func didUpdateEqaulizerLevel() {
        let currentTime = Date()
        let maxDotCount = 30
        if currentTime.timeIntervalSince(lastUpdateTime) >= 1.0 {
            lastUpdateTime = currentTime
            eqaulizerIndex = min(eqaulizerIndex + 1, maxDotCount)
        }
        equalizerLevels = Array(equalizerLevels.prefix(maxDotCount))
        setNeedsDisplay()
    }
    
}
