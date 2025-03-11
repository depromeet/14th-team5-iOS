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
   
    private var selectedIndex: Int?
    private var originPostLists: PostSection.Model?
    
    private var postId: String?
    
    init(selectedIndex: Int, originPostLists: PostSection.Model) {
        self.selectedIndex = selectedIndex
        self.originPostLists = originPostLists
    }
    
    init(postId: String) {
        self.postId = postId
    }
    
    func makeReactor() -> R {
        if let selectedIndex,
           let originPostLists {
            return PostReactor(
                selectedIndex: selectedIndex,
                originPostLists: originPostLists
            )
        }
        
        return PostReactor(postId: postId)
    }
}
