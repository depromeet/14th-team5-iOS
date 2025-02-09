//
//  NotificationRepository.swift
//  Data
//
//  Created by 마경미 on 29.01.25.
//

import Domain

import RxSwift

public final class NotificationRepository: NotificationRepositoryPorotocol {
    private let notificationAPIWorker: NotificationAPIWorker = NotificationAPIWorker()
    
    public init() { }
}

extension NotificationRepository {
//    public func fetchNotifications() -> Observable<[NotificationEntity]> {
//        return notificationAPIWorker.fetchNotifications()
//            .map { $0.map { $0.toDomain() } }
//    }
    
    public func fetchNotifications() -> Observable<[NotificationEntity]> {
        return Observable.just([
            .init(id: "123", style: "BIRTHDAY", senderImageUrl: "https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNDA2MDZfMjE2%2FMDAxNzE3NjcyMjA2NTU1.Z0GGIuD4IPf87kI5EU2FqyqTipRKo8J2jldgBOGenTYg.qB3gOIK3QKc89QKfe_8QnaGXeoVJA9Sn1rq4OahAFD8g.JPEG%2Fpublicdomainq-0065070tpnxng.jpg&type=sc960_832", title: "누구의 생일이에여!!", content: "생일이라니까?!", deepLink: "아몰랑", createdAt: "아몰류ㅠ")
//            .init(id: <#T##String#>, style: <#T##String#>, senderImageUrl: <#T##String#>, title: <#T##String#>, content: <#T##String#>, deepLink: <#T##String#>, createdAt: <#T##String#>),
//            .init(id: <#T##String#>, style: <#T##String#>, senderImageUrl: <#T##String#>, title: <#T##String#>, content: <#T##String#>, deepLink: <#T##String#>, createdAt: <#T##String#>)
        ])
    }
}

