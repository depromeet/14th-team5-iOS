//
//  MissionUserDefaultsRepository.swift
//  Data
//
//  Created by 마경미 on 03.06.24.
//

import Foundation

import Domain

import RxSwift

public final class MissionUserDefaultsRepository: MissionUserdefaultsRepositoryProtocol {
    
    private let lastMissionUploadDateId = "lastMissionUploadDateId"
    
    public init() { }
    
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
