//
//  PostCommentStrings.swift
//  App
//
//  Created by 김건우 on 1/31/24.
//

import Foundation

typealias PostCommentStrings = String.PostComment
extension String {
    enum PostComment { }
}

extension PostCommentStrings {
    static let commentDeleteText = "댓글이 삭제되었습니다"
    static let commentFetchFailureText = "댓글을 불러오는데 실패했어요"
}
