//
//  CommentViewControllerWrapper.swift
//  App
//
//  Created by 김건우 on 6/25/24.
//

import Core
import Foundation
import MacrosInterface

@Wrapper<CommentViewReactor, CommentViewController>
final class CommentViewControllerWrapper {

    // MARK: - Properties
    
    let postId: String
    
    // MARK: - Intializer
    
    init(postId: String) {
        self.postId = postId
    }
    
    // MARK: - Make
    
    func makeReactor() -> CommentViewReactor {
        CommentViewReactor(postId: postId)
    }
    
}
