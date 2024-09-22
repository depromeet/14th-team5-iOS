//
//  ReactionViewControllerWrapper.swift
//  App
//
//  Created by 마경미 on 17.06.24.
//

import Core
import Domain
import Foundation
import MacrosInterface

@Wrapper<ReactionViewReactor, ReactionViewController>
final class ReactionViewControllerWrapper {
    
    private let type: ReactionType
    private let postListData: PostEntity
    
    init(type: ReactionType, postListData: PostEntity) {
        self.type = type
        self.postListData = postListData
    }
    
    func makeReactor() -> R {
        return ReactionViewReactor(initialState: .init(type: type, postListData: postListData))
    }
    
}
