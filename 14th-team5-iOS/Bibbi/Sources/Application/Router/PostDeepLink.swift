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
        // NOTE: FCM 아니기 때문에 무조건 openTodayPost로 포스트 디테일 단 한개만 연다.
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
        guard pathComponents.count >= 3,
              let _ = queryParams?.first(where: { $0.name == "dateOfPost" })?.value,
              let isComment = queryParams?.first(where: { $0.name == "openComment" })?.value else {
            return
        }
        
        type = .openTodayPost(pathComponents[2])
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
            openMainPostComment(postId
            )
        case let .openCalenderPostComment(postId):
            openCalendarPostComment(postId)
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
