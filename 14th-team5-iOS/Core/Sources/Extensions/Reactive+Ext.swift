//
//  Reactive+Ext.swift
//  App
//
//  Created by Kim dohyun on 12/15/23.
//

import UIKit
import WebKit

import Kingfisher
import RxCocoa
import RxSwift

extension Reactive where Base: UIViewController {
    public var viewWillAppear: ControlEvent<Bool> {
        let event = self.methodInvoked(#selector(Base.viewWillAppear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: event)
    }
    
    public var viewDidDisappear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewDidDisappear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
      }
}

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
    
    public var longPress: ControlEvent<UILongPressGestureRecognizer> {
        let gestureRecognizer = UILongPressGestureRecognizer()
        self.base.addGestureRecognizer(gestureRecognizer)
        
        return ControlEvent(events: gestureRecognizer.rx.event)
    }
}

extension Reactive where Base: UITapGestureRecognizer {
    public var tapGesture: ControlEvent<Void> {
        let tapEvent = self.methodInvoked(#selector(Base.touchesBegan(_:with:))).map { _ in }
        return ControlEvent(events: tapEvent)
    }
}

extension Reactive where Base: UILabel {
    
    public var firstLetterText: Binder<String> {
        Binder(self.base) { label, text in
            if let firstLetter = text.first {
                label.text = String(firstLetter)
            }
        }
    }
    
    @available(*, deprecated, message: "삭제")
    public var calendarTitleText: Binder<Date> {
        Binder(self.base) { label, date in
            var formatString: String = .none
            if date.isEqual([.year], with: Date()) {
                formatString = date.toFormatString(with: .m)
            } else {
                formatString = date.toFormatString(with: .yyyyM)
            }
            label.text = formatString
        }
    }
    
    @available(*, deprecated, message: "삭제")
    public var memoryCountText: Binder<Int> {
        Binder(self.base) { label, count in
            label.text = "\(count)개의 추억"
        }
    }
}

extension Reactive where Base: WKWebView {
    public var loadURL: Binder<URL> {
        return Binder(self.base) { webView, url in
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
    }
}

extension Reactive where Base: UIImageView {
    public var kingfisherImage: Binder<String> {
        Binder(self.base) { imageView, urlString in
            imageView.kf.setImage(
                with: URL(string: urlString),
                options: [
                    .transition(.fade(0.15))
                ]
            )
        }
    }
}
