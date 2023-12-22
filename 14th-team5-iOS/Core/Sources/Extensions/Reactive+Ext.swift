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
}

extension Reactive where Base: UITapGestureRecognizer {
    public var tapGesture: ControlEvent<Void> {
        let tapEvent = self.methodInvoked(#selector(Base.touchesBegan(_:with:))).map { _ in }
        return ControlEvent(events: tapEvent)
    }
}

extension Reactive where Base: UILabel {
    public var calendarTitle: Binder<Date> {
        Binder(self.base) { label, date in
            let text = DateFormatter.yyyyMM.string(from: date)
            label.text = text
        }
    }
}
