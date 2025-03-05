//
//  FetchNotificationUseCase.swift
//  Domain
//
//  Created by 마경미 on 30.01.25.
//

import RxSwift

public protocol FetchNotificationUseCaseProtocol {
    func execute() -> Observable<[NotificationEntity]>
}

public class FetchNotificationUseCase: FetchNotificationUseCaseProtocol {
    private let notificationRepository: NotificationRepositoryPorotocol
    private let familyRepository: FamilyRepositoryProtocol
    
    public init(
        notificationRepository: NotificationRepositoryPorotocol,
        familyRepository: FamilyRepositoryProtocol
    ) {
        self.notificationRepository = notificationRepository
        self.familyRepository = familyRepository
    }
    
    public func execute() -> Observable<[NotificationEntity]> {
        return notificationRepository.fetchNotifications()
            .map { notifis in
                let members = self.familyRepository.loadAllFamilyMembers()
                return notifis.map { notification in
                    var updatedNotification = notification
                    if let members,
                       let member = members.first(where: {
                           $0.memberId == notification.sender?.memberId
                       }) {
                        updatedNotification.sender = .init(
                            memberId: member.memberId,
                            profileImageURL: notification.sender?.profileImageURL,
                            name: member.name,
                            isShowBirthdayMark: notification.sender?.isShowBirthdayMark ?? false
                        )
                    }
                    return updatedNotification
                }
            }
    }
}
