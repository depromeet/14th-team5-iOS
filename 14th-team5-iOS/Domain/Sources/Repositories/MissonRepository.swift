//
//  MissonRepository.swift
//  Domain
//
//  Created by 김도현 on 11/20/24.
//

import Foundation

import RxSwift


public protocol MissionRepositoryProtocol {
    
    /// FETCH
    func fetchMissonContentItem(missonId: String) -> Observable<MissionContentEntity?>
    func fetchDailyMissonItem() -> Observable<CameraTodayMssionEntity?>
    
    /// LOCAL DB
    func isAlreadyShowMissionAlert() -> Observable<Bool>
    func updateMissonUploadDate()
}
