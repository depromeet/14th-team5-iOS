//
//  SelectableEmojiViewControllerWrapper.swift
//  App
//
//  Created by 마경미 on 17.06.24.
//

import Foundation

import Core

import RxSwift

final class SelectableEmojiViewControllerWrapper {
    typealias R = SelectableEmojiReactor
    typealias V = SelectableEmojiViewController
    
    private let subject: PublishSubject<Void>
    private let postId: String
    
    init(subject: PublishSubject<Void>, postId: String) {
        self.subject = subject
        self.postId = postId
    }
    
    func makeViewController() -> V {
        return SelectableEmojiViewController(reactor: makeReactor(), selectedReactionSubject: subject)
    }
    
    func makeReactor() -> R {
        return SelectableEmojiReactor(postId: postId)
    }
    
    var viewController: V {
        makeViewController()
    }
    
    var reactor: R {
        makeReactor()
    }
}
