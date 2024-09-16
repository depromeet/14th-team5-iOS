//
//  CommentViewControllerWrapper.swift
//  App
//
//  Created by 김건우 on 6/25/24.
//

import Core
import Foundation

final class CommentViewControllerWrapper: BaseWrapper {
    
    // MARK: - Typealias
    
    typealias R = CommentViewReactor
    typealias V = CommentViewController
    
    // MARK: - Properties
    
    let postId: String
    
    var reactor: CommentViewReactor {
        makeReactor()
    }
    
    var viewController: CommentViewController {
        makeViewController()
    }
    
    // MARK: - Intializer
    
    init(postId: String) {
        self.postId = postId
    }
    
    // MARK: - Make
    
    func makeReactor() -> CommentViewReactor {
        CommentViewReactor(postId: postId)
    }
    
    func makeViewController() -> CommentViewController {
        CommentViewController(reactor: makeReactor())
    }
    
}
