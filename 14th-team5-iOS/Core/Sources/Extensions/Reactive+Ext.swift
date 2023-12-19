//
//  Reactive+Ext.swift
//  App
//
//  Created by Kim dohyun on 12/15/23.
//

import UIKit

import RxCocoa
import RxSwift


extension Reactive where Base: UIView {
    public var tapGesture: UITapGestureRecognizer {
        return UITapGestureRecognizer()
    }

    public var tap: ControlEvent<Void> {
        let tapGestureRecognizer = tapGesture
        base.addGestureRecognizer(tapGestureRecognizer)

        return tapGestureRecognizer.rx.tapGesture
    }
    
    public var pinchGesture: ControlEvent<UIPinchGestureRecognizer> {
        let pinchGestureRecognizer = UIPinchGestureRecognizer()
        base.addGestureRecognizer(pinchGestureRecognizer)

        return ControlEvent(events: pinchGestureRecognizer.rx.event)
    }
}

extension Reactive where Base: UITapGestureRecognizer {
    public var tapGesture: ControlEvent<Void> {
        let tapEvent = self.methodInvoked(#selector(Base.touchesBegan(_:with:))).map { _ in }
        return ControlEvent(events: tapEvent)
    }
}

extension Reactive where Base: UILabel {
    public var isMeText: Binder<Bool> {
        Binder(self.base) { label, isMe in
            label.text = isMe ? "ME" : ""
        }
    }
    
    public var calendarTitleText: Binder<Date> {
        Binder(self.base) { label, date in
            let text = DateFormatter.yyyyMM.string(from: date)
            label.text = text
        }
    }
}

extension Reactive where Base: UIStackView {
    public var isMeSpacing: Binder<Bool> {
        Binder(self.base) { stackView, isMe in
            stackView.spacing = isMe ? 3.0 : 0.0
        }
    }
}
