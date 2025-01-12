//
//  CommentTextFieldDelegateProxy.swift
//  App
//
//  Created by 김건우 on 9/12/24.
//

import UIKit

import RxCocoa
import RxSwift

public class RxCommentTextFieldDelegateProxy: DelegateProxy<CommentTextFieldView, CommentTextFieldDelegate>, DelegateProxyType, CommentTextFieldDelegate {
    
    static public func registerKnownImplementations() {
        self.register {
            RxCommentTextFieldDelegateProxy(
                parentObject: $0,
                delegateProxy: self
            )
        }
    }
    
}

extension CommentTextFieldView: HasDelegate {
    
    public typealias Delegate = CommentTextFieldDelegate
    
}

extension Reactive where Base: CommentTextFieldView {
    
    public var delegate: DelegateProxy<CommentTextFieldView, CommentTextFieldDelegate> {
        RxCommentTextFieldDelegateProxy.proxy(for: self.base)
    }
    
    public var didTapConfirmButton: Observable<String> {
        let source = delegate.sentMessage(#selector(CommentTextFieldDelegate.didTapConfirmButton(_:text:event:)))
            .map { $0[1] as! String }
        
        return source
    }
    
    public var didTapDoneButton: Observable<String> {
        let source = delegate.sentMessage(#selector(CommentTextFieldDelegate.didTapDoneButton(text:)))
            .map { $0[0] as! String }
        
        return source
    }
    
}
