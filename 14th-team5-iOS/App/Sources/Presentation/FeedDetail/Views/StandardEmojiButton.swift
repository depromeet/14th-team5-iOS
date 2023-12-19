//
//  EmojiButton.swift
//  App
//
//  Created by 마경미 on 14.12.23.
//

import UIKit
import DesignSystem
import RxCocoa
import RxSwift

final class StandardEmojiButton: UIView {
    private let backgroundView: UIImageView = UIImageView()
    private let emojiLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setAutoLayout()
        setAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubviews(backgroundView, emojiLabel)
    }
    
    private func setAutoLayout() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        emojiLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func setAttributes() {
        backgroundView.do {
            $0.image = DesignSystemAsset.dotEllipse.image
        }
    }
}

extension StandardEmojiButton {
    func setEmoji(emoji: Emojis) {
        emojiLabel.text = emoji.emojiString
    }
}

//extension Reactive where Base: EmojiButton {
//    var tap: ControlEvent<Void> {
//        let tapGestureRecognizer = UITapGestureRecognizer()
//
//        base.isUserInteractionEnabled = true
//        base.addGestureRecognizer(tapGestureRecognizer)
//
//        return ControlEvent(events: tapGestureRecognizer.rx.event.map { _ in })
//    }
//}
