//
//  CommentUserDefaults.swift
//  Data
//
//  Created by 김건우 on 8/24/24.
//

import Core
import Foundation


public protocol CommentUserDefaultsType: UserDefaultsType {
    func saveCommentSnapshot(_ snapshot: CommentSnapshot?)
    func loadCommentSnapshot() -> CommentSnapshot?
}

public final class CommentUserDefaults: CommentUserDefaultsType {
    
    // MARK: - Intializer
    
    public init() { }
    
    
    // MARK: - Comment Snapshot
    
    public func saveCommentSnapshot(_ snapshot: CommentSnapshot?) {
        userDefaults[.commentSnapshot] = snapshot
    }
    
    public func loadCommentSnapshot() -> CommentSnapshot? {
        guard
            let snapshot: CommentSnapshot? = userDefaults[.commentSnapshot]
        else { return nil }
        return snapshot
    }
    
}
