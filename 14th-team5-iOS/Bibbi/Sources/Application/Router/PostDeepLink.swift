//
//  PostDeepLink.swift
//  Bibbi
//
//  Created by 마경미 on 24.02.25.
//

import Foundation

import Core

// MARK: - Post 딥링크
final class PostDeepLink: DeepLinkProtocol {
    enum PostDeepLinkType {
        case openTodayPost
        case openCalendarPost
        
        case openTodayPostComment
        case openCalenderPostComment
    }
    
    let type: PostDeepLinkType
    
    init(
        pathComponents: [String],
        queryParams: [URLQueryItem]?
    ) {
        guard let date = queryParams?.first(where: {
            $0.name == "dateOfPost"})?.value,
              let isComment = queryParams?.first(where: {
                  $0.name == "openComment"})?.value else {
            BBToast.text("화면을 이동할 수 없어요").show()
            return
        }
        
        if date == "hi" {
            type = isComment == "true" ?
                .openTodayPostComment : .openTodayPost
        } else {
            type = isComment == "true" ?
                .openCalenderPostComment : .openCalendarPost
        }
    }
    
    func doDeepLink() {
        switch type {
        case .openTodayPost: openMainPost()
        case .openCalendarPost: openCalendarPost()
        case .openTodayPostComment: openMainPostComment()
        case .openCalenderPostComment:
        }
    }
}

extension PostDeepLink {
    private func openMainPost() {
        
    }
    
    private func openCalendarPost() {
        
    }
    
    private func openMainPostComment() {
        
    }
    
    private func openCalendarPostComment() {
        
    }
}
