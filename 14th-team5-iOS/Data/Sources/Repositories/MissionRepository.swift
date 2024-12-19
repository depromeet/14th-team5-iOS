//
//  MissionRepository.swift
//  Data
//
//  Created by 마경미 on 21.04.24.
//

import Foundation

import Core
import Domain

import RxSwift

public final class MissionRepository: MissionRepositoryProtocol {
    
    public let disposeBag: DisposeBag = DisposeBag()
    
    private let lastMissionUploadDateId = "lastMissionUploadDateId"
    private let missionAPIWorker: MissionAPIWorker = MissionAPIWorker()
    
    public init() { }
}

extension MissionRepository {
    
    public func fetchMissonContentItem(missonId: String) -> Observable<MissionContentEntity> {
        return missionAPIWorker.fetchMissonContent(missonId: missonId)
            .map { $0.toDomain() }
    }
    
    public func fetchDailyMissonItem() -> Observable<MissonTodayContentEntity> {
        return missionAPIWorker.fetchDailyMisson()
            .map { $0.toDomain() }
    }
    
    public func isAlreadyShowMissionAlert() -> Observable<Bool> {
        guard let lastDate = UserDefaults.standard.string(forKey: lastMissionUploadDateId) else {
            updateMissonUploadDate()
            return .just(false)
        }
        
        if lastDate == Date().toFormatString(with: "yyyy-MM-dd") {
            return .just(true)
        } else {
            updateMissonUploadDate()
            return .just(false)
        }
    }
    
    public func updateMissonUploadDate() {
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let extractedDate = dateFormatter.string(from: Date())
        UserDefaults.standard.set(extractedDate, forKey: lastMissionUploadDateId)
    }
}
