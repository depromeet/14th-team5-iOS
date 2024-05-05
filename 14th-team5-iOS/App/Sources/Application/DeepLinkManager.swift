//
//  DeepLinkManager.swift
//  App
//
//  Created by 마경미 on 05.05.24.
//

import UIKit

import Core
import Data
import Domain

import RxSwift

class DeepLinkManager {
    static let shared = DeepLinkManager()
    
    // 이번 3차 끝나고, postdetailviewcontroller에서 post 불러오는 형태로 바꿔보겠습니다.
    let disposeBag: DisposeBag = DisposeBag()
    let postRepository: PostListRepositoryProtocol = PostListAPIs.Worker()
    lazy var postUseCase: PostListUseCaseProtocol = PostListUseCase(postListRepository: postRepository)
    
    private init() {}
    
    func handleDeepLink(_ deepLink: NotificationDeepLink) {
    }
    
    func handlePostWidgetDeepLink(_ deepLink: WidgetDeepLink) {
        let query = PostListQuery(date: DateFormatter.dashYyyyMMdd.string(from: Date()), type: .survival)
        postUseCase.excute(query: query)
            .subscribe(onSuccess: { [weak self] result in
                guard let self = self, let result = result else { return }
                
                let items = result.postLists.map(PostSection.Item.main)
                
                items.enumerated().forEach { (index, item) in
                    switch item {
                    case .main(let postListData):
                        if postListData.postId == deepLink.postId {
                            let indexPath = IndexPath(row: index, section: 0)
                            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                               let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }),
                               let navigationController = keyWindow.rootViewController as? UINavigationController {
                                let viewController = PostListsDIContainer().makeViewController(
                                    postLists: PostSection.Model(model: 0, items: items),
                                    selectedIndex: IndexPath(row: index, section: 0)
                                )
                                navigationController.pushViewController(viewController, animated: true)
                            }
                        }
                    }
                }
            }, onFailure: { error in
                // 에러 처리
            })
            .disposed(by: disposeBag)
    }

    
//    private func handlePostNotificationDeepLink(_ deepLink: NotificationDeepLink) {
//        guard let reactor = reactor else { return }
//        reactor.currentState.postSection.items.enumerated().forEach { (index, item) in
//            switch item {
//            case .main(let post):
//                if post.postId == deepLink.postId {
//                    let indexPath = IndexPath(row: index, section: 0)
//                    self.navigationController?.pushViewController(
//                        PostListsDIContainer().makeViewController(
//                            postLists: reactor.currentState.postSection,
//                            selectedIndex: indexPath),
//                        animated: true
//                    )
//                }
//            }
//        }
//    }
//    
//    private func handleCommentNotificationDeepLink(_ deepLink: NotificationDeepLink) {
//        guard let reactor = reactor else { return }
//        
//        // 오늘 올린 피드에 댓글이 달렸다면
//        if deepLink.dateOfPost.isToday {
//            guard let selectedIndex = reactor.currentState.postSection.items.firstIndex(where: { postList in
//                switch postList {
//                case let .main(post):
//                    post.postId == deepLink.postId
//                }
//            }) else { return }
//            let indexPath = IndexPath(row: selectedIndex, section: 0)
//            
//            let postListViewController = PostListsDIContainer().makeViewController(
//                postLists: reactor.currentState.postSection,
//                selectedIndex: indexPath,
//                notificationDeepLink: deepLink
//            )
//            
//            navigationController?.pushViewController(
//                postListViewController,
//                animated: true
//            )
//            // 이전에 올린 피드에 댓글이 달렸다면
//        } else {
//            let calendarPostViewController = CalendarPostDIConatainer(
//                selectedDate: deepLink.dateOfPost,
//                notificationDeepLink: deepLink
//            ).makeViewController()
//            
//            navigationController?.pushViewController(
//                calendarPostViewController,
//                animated: true
//            )
//        }
//    }
}
