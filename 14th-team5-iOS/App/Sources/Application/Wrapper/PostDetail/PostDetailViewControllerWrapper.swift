//
//  PostDetailViewControllerWrapper.swift
//  App
//
//  Created by 마경미 on 17.06.24.
//

import Foundation

import Core

final class PostDetailViewControllerWrapper: BaseWrapper {
    typealias R = PostReactor
    typealias V = PostViewController
    
    private let selectedIndex: Int
    private let originPostLists: PostSection.Model
    
    init(selectedIndex: Int, originPostLists: PostSection.Model) {
        self.selectedIndex = selectedIndex
        self.originPostLists = originPostLists
    }
    
    func makeViewController() -> V {
        return PostViewController(reactor: makeReactor())
    }
    
    func makeReactor() -> R {
        return PostReactor(initialState: .init(selectedIndex: selectedIndex, originPostLists: originPostLists))
    }
    
    var viewController: V {
        makeViewController()
    }
    
    var reactor: R {
        makeReactor()
    }
}
