//
//  PostCommentDIContainer.swift
//  App
//
//  Created by 김건우 on 1/18/24.
//

import Core
import UIKit

public final class PostCommentDIContainer {
    // MARK: - Properties
    private var globalState: GlobalStateProviderProtocol {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return GlobalStateProvider()
        }
        return appDelegate.globalStateProvider
    }
    
    private var commentCount: Int
    
    // MARK: - Intializer
    public init(commentCount: Int) {
        self.commentCount = commentCount
    }
    
    // MARK: - Make
    public func makeViewController() -> PostCommentViewController {
        return PostCommentViewController(reactor: makeReactor())
    }
    
    public func makeReactor() -> PostCommentViewReactor {
        return PostCommentViewReactor(
            commentCount: commentCount,
            provider: globalState
        )
    }
}
