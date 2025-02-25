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
        case openTodayPost(String)
        case openCalendarPost(String)
        
        case openTodayPostComment(String)
        case openCalenderPostComment(String)
    }
    
    var type: PostDeepLinkType?
    
    init(
        pathComponents: [String],
        queryParams: [URLQueryItem]?
    ) {
        guard pathComponents.count > 3 else { return }
        guard let date = queryParams?.first(where: { $0.name == "dateOfPost" })?.value,
              let isComment = queryParams?.first(where: { $0.name == "openComment" })?.value else { return }
        
        let postId = pathComponents[2]
        let isToday = (date == "hi")
        let hasComment = (isComment == "true")
        
        type = isToday
        ? (hasComment ?
            .openTodayPostComment(postId)
           : .openTodayPost(postId)
        ): (hasComment ?
            .openCalenderPostComment(postId)
            : .openCalendarPost(postId)
        )
    }
    
    func doDeepLink() throws {
        guard let type else {
            throw DeepLinkError.invalidLink
        }
        
        switch type {
        case let .openTodayPost(postId):
            openMainPost(postId)
        case let .openCalendarPost(postId):
            openCalendarPost(postId)
        case let .openTodayPostComment(postId):
            openMainPostComment(postId)
        case let .openCalenderPostComment(postId): openCalendarPostComment(postId)
        }
    }
}

extension PostDeepLink {
    private func openMainPost(_ postId: String) {
        let viewController = PostDetailViewControllerWrapper(
            postId: postId
        ).viewController
        
        getNavigationController()?.pushViewController(
            viewController,
            animated: true
        )
    }
    
    private func openCalendarPost(_ postId: String) {
        
    }
    
    private func openMainPostComment(_ postId: String) {
        
    }
    
    private func openCalendarPostComment(_ postId: String) {
        
    }
}
