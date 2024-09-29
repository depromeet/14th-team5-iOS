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

enum DeepLinkType {
    /// 위젯 눌러 메인 진입
    case Widget
    /// 푸시알림으로 오늘 생존신고 피드로 진입
    case TodaySurvival
    /// 푸시알림으로 오늘 미션 피드로 진입
    case TodayMission
    
    
    case TodayComment
    case SomedayComment
}

final class DeepLinkManager {
    static let shared = DeepLinkManager()
    
    // 이번 3차 끝나고, postdetailviewcontroller에서 post 불러오는 형태로 바꿔보겠습니다.
    let disposeBag: DisposeBag = DisposeBag()
    let postRepository: PostListRepositoryProtocol = PostRepository()
    let familyRepository: FamilyRepositoryProtocol = FamilyRepository()
    lazy var postUseCase: FetchPostListUseCaseProtocol = FetchPostListUseCase(
        postListRepository: postRepository, familyRepository: familyRepository)
    
    private init() {}
    
    private func todayDeepLink(type: PostType, data: NotificationDeepLink) {
        fetchTodayPost(type: type) { result in
            guard let result = result else { return }
            let items = result.map(PostSection.Item.main)
            
            items.enumerated().forEach { (index, item) in
                switch item {
                case .main(let postListData):
                    if postListData.postId == data.postId {
                        let indexPath = IndexPath(row: index, section: 0)
                        self.pushViewController(data: nil, index: indexPath, items: items)
                    }
                }
            }
        }
    }
    
    private func todayCommentDeepLink(type: PostType, data: NotificationDeepLink) {
        fetchTodayPost(type: type) { result in
            guard let result = result else { return }
            let items = result.map(PostSection.Item.main)
            
            items.enumerated().forEach { (index, item) in
                switch item {
                case .main(let postListData):
                    if postListData.postId == data.postId {
                        let indexPath = IndexPath(row: index, section: 0)
                        self.pushViewController(data: data, index: indexPath, items: items)
                    }
                }
            }
        }
        
    }

    private func fetchTodayPost(type: PostType, completion: @escaping ([PostEntity]?) -> Void) {
        let dateString = Date().toFormatString(with: "yyyy-MM-dd")
        let query = PostListQuery(date: dateString, type: type)
        
        postUseCase.execute(query: query)
            .subscribe(onNext: { result in
                completion(result)
            })
            .disposed(by: disposeBag)
    }
    
    private func pushViewController(data: NotificationDeepLink?, index: IndexPath, items: [PostSection.Item]) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }),
           let navigationController = keyWindow.rootViewController as? UINavigationController {
            let viewController = PostDetailViewControllerWrapper(
                selectedIndex: index.row,
                originPostLists: PostSection.Model(model: 0, items: items)
            ).makeViewController()
            navigationController.pushViewController(viewController, animated: true)
        }
    }
    
    private func pushCalendarViewController(data: NotificationDeepLink) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }),
           let navigationController = keyWindow.rootViewController as? UINavigationController {
            let viewController = WeeklyCalendarDIConatainer(
                date: data.dateOfPost,
                deepLink: data
            ).makeViewController()
            
            navigationController.pushViewController(viewController, animated: true)
        }
    }
}

extension DeepLinkManager {
    func handleWidgetDeepLink(data: WidgetDeepLink) {
        fetchTodayPost(type: .survival) { result in
            guard let result = result else { return }
            let items = result.map(PostSection.Item.main)
            
            items.enumerated().forEach { (index, item) in
                switch item {
                case .main(let postListData):
                    if postListData.postId == data.postId {
                        let indexPath = IndexPath(row: index, section: 0)
                        self.pushViewController(data: nil, index: indexPath, items: items)
                    }
                }
            }
        }
    }
    
    func handleDeepLink(data: NotificationDeepLink) {
        var type: DeepLinkType = .TodaySurvival
        if data.openComment {
            if data.dateOfPost.isToday {
                type = .TodayComment
            } else {
                type = .SomedayComment
            }
        }
        
        switch type {
        case .TodaySurvival:
            todayDeepLink(type: .survival, data: data)
        case .TodayMission:
            todayDeepLink(type: .mission, data: data)
        case .TodayComment:
            todayCommentDeepLink(type: .survival, data: data)
        case .SomedayComment:
            pushCalendarViewController(data: data)
        default:
            fatalError("원하는 정보를 찾을 수 없습니다.")
        }
    }
    
    func decodeRemoteNotificationDeepLink(_ userInfo: [AnyHashable: Any]) {
        if let link = userInfo[AnyHashable("iosDeepLink")] as? String {
            let components = link.components(separatedBy: "?")
            let parameters = components.last?.components(separatedBy: "&")

            // PostID 구하기
            let postId = components.first?.components(separatedBy: "/").last ?? ""

            // OpenComment 구하기
            let firstPart = parameters?.first
            let openComment = firstPart?.components(separatedBy: "=").last == "true" ? true : false

            // dateOfPost 구하기
            let secondPart = parameters?.last
            let dateOfPost = secondPart?.components(separatedBy: "=").last?.toDate() ?? Date()
            
            let deepLink = NotificationDeepLink(
                postId: postId,
                openComment: openComment,
                dateOfPost: dateOfPost
            )
            
            handleDeepLink(data: deepLink)
        } else {
            print("Error: Decoding Notification Request UserInfo")
        }
    }
}
