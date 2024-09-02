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

    public func getMissionContent(missionId: String) -> Single<MissionContentEntity?> {
        return missionAPIWorker.getMissionContent(missionId: missionId)
    }
    
    public func isAlreadyShowMissionAlert() -> Observable<Bool> {
        guard let lastDate = UserDefaults.standard.string(forKey: lastMissionUploadDateId) else {
            saveMissionUploadDate()
            return .just(false)
        }
        
        if lastDate == Date().toFormatString(with: "yyyy-MM-dd") {
            return .just(true)
        } else {
            saveMissionUploadDate()
            return .just(false)
        }
    }
    
    private func saveMissionUploadDate() {
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let extractedDate = dateFormatter.string(from: Date())
        UserDefaults.standard.set(extractedDate, forKey: lastMissionUploadDateId)
    }
}
