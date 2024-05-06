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
    
    
    case Comment
    
//    /// 푸시알림으로 오늘 생존신고 피드의 댓글까지 진입
//    case TodaySurvivalComment
//    /// 푸시알림으로 오늘 미션 피드의 댓글까지 진입
//    case TodayMissionComment
//    /// 푸시알림으로 오늘 아닌 날짜의 캘린더 피드까지 진입
//    case SomedayPostComment
}

final class DeepLinkManager {
    static let shared = DeepLinkManager()
    
    // 이번 3차 끝나고, postdetailviewcontroller에서 post 불러오는 형태로 바꿔보겠습니다.
    let disposeBag: DisposeBag = DisposeBag()
    let postRepository: PostListRepositoryProtocol = PostListAPIs.Worker()
    lazy var postUseCase: PostListUseCaseProtocol = PostListUseCase(postListRepository: postRepository)
    
    private init() {}
    
    func handleWidgetDeepLink(data: WidgetDeepLink) {
        fetchTodayPost(type: .survival) { result in
            guard let result = result else { return }
            let items = result.postLists.map(PostSection.Item.main)
            
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
    
    func handleDeepLink(type: DeepLinkType, data: NotificationDeepLink) {
        switch type {
        case .TodaySurvival:
            todayDeepLink(type: .survival, data: data)
        case .TodayMission:
            todayDeepLink(type: .mission, data: data)
        case .Comment:
            if data.dateOfPost == Date() {
                todayCommentDeepLink(type: .survival, data: data)
            } else {
                pushCalendarViewController(data: data)
            }
        default:
            fatalError("원하는 정보를 찾을 수 없습니다.")
        }
    }
    
    private func todayDeepLink(type: PostType, data: NotificationDeepLink) {
        fetchTodayPost(type: type) { result in
            guard let result = result else { return }
            let items = result.postLists.map(PostSection.Item.main)
            
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
            let items = result.postLists.map(PostSection.Item.main)
            
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
}

extension DeepLinkManager {
    private func fetchTodayPost(type: PostType, completion: @escaping (PostListPage?) -> Void) {
        let dateString = DateFormatter.dashYyyyMMdd.string(from: Date())
        let query = PostListQuery(date: dateString, type: type)
        
        postUseCase.excute(query: query)
            .subscribe(onSuccess: { result in
                completion(result)
            })
            .disposed(by: disposeBag)
    }
    
    private func pushViewController(data: NotificationDeepLink?, index: IndexPath, items: [PostSection.Item]) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }),
           let navigationController = keyWindow.rootViewController as? UINavigationController {
            let viewController = PostListsDIContainer().makeViewController(
                postLists: PostSection.Model(model: 0, items: items),
                selectedIndex: index,
                notificationDeepLink: data
            )
            navigationController.pushViewController(viewController, animated: true)
        }
    }
    
    private func pushCalendarViewController(data: NotificationDeepLink) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }),
           let navigationController = keyWindow.rootViewController as? UINavigationController {
            let viewController = CalendarPostDIConatainer(
                selectedDate: data.dateOfPost,
                notificationDeepLink: data
            ).makeViewController()
            
            navigationController.pushViewController(viewController, animated: true)
        }
    }
}
