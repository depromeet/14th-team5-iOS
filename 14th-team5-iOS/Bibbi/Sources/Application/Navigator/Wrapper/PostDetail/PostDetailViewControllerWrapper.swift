//
//  PostDetailViewControllerWrapper.swift
//  App
//
//  Created by 마경미 on 17.06.24.
//

import Core
import Foundation
import MacrosInterface

@Wrapper<PostReactor, PostViewController>
final class PostDetailViewControllerWrapper {
   
    private let selectedIndex: Int
    private let originPostLists: PostSection.Model
    
    init(selectedIndex: Int, originPostLists: PostSection.Model) {
        self.selectedIndex = selectedIndex
        self.originPostLists = originPostLists
    }
    
    func makeReactor() -> R {
        return PostReactor(initialState: .init(selectedIndex: selectedIndex, originPostLists: originPostLists))
    }
  
}
