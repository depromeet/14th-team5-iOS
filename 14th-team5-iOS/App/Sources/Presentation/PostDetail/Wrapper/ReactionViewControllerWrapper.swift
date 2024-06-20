//
//  ReactionViewControllerWrapper.swift
//  App
//
//  Created by 마경미 on 17.06.24.
//

import Foundation

import Core
import Domain

final class ReactionViewControllerWrapper: BaseWrapper {
    typealias R = ReactionViewReactor
    typealias V = ReactionViewController
    
    private let type: ReactionType
    private let postListData: PostEntity
    
    init(type: ReactionType, postListData: PostEntity) {
        self.type = type
        self.postListData = postListData
    }
    
    func makeViewController() -> V {
        return ReactionViewController(reactor: makeReactor())
    }
    
    func makeReactor() -> R {
        return ReactionViewReactor(initialState: .init(type: type, postListData: postListData))
    }
    
    var viewController: V {
        makeViewController()
    }
    
    var reactor: R {
        makeReactor()
    }
}
