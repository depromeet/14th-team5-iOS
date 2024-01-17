//
//  CalendarAPIWorker.swift
//  Data
//
//  Created by 김건우 on 12/21/23.
//

import Foundation

import Alamofire
import Domain
import RxSwift

typealias CalendarAPIWorker = CalendarAPIs.Worker
extension CalendarAPIs {
    final class Worker: APIWorker {
        static let queue = {
            ConcurrentDispatchQueueScheduler(queue: DispatchQueue(label: "CalendarAPIQueue", qos: .utility))
        }()
        
        override init() {
            super.init()
            self.id = "CalendarAPIWorker"
        }
    }
}

extension CalendarAPIWorker {
    private func fetchCalendarInfo(spec: APISpec, headers: [BibbiHeader]) -> Single<ArrayResponseCalendarResponse?> {
        return request(spec: spec, headers: headers)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("CalendarInfo Fetch Result: \(str)")
                }
            }
            .map(ArrayResponseCalendarResponseDTO.self)
            .catchAndReturn(nil)
            .map { $0?.toDomain() }
            .asSingle()
    }
    
    public func fetchCalendarInfo(_ yearMonth: String, token accessToken: String) -> Single<ArrayResponseCalendarResponse?> {
        let spec = CalendarAPIs.calendarInfo(yearMonth).spec
        let headers: [BibbiHeader] = [.acceptJson, .xAppKey, .xAuthToken(accessToken)]
        
        return fetchCalendarInfo(spec: spec, headers: headers)
    }
    
    private func fetchFamilyStatisticsInfo(spec: APISpec, headers: [BibbiHeader]) -> Single<FamilyMonthlyStatisticsResponse?> {
        return request(spec: spec, headers: headers)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("FamilySummaryInfo Fetch Result: \(str)")
                }
            }
            .map(FamilyMonthlyStatisticsResponseDTO.self)
            .catchAndReturn(nil)
            .map { $0?.toDomain() }
            .asSingle()
    }
    
    public func fetchFamilyStatisticsInfo(token accessToken: String, familyId: String) -> Single<FamilyMonthlyStatisticsResponse?> {
        let spec = CalendarAPIs.familySummaryInfo(familyId).spec
        let headers: [BibbiHeader] = [.acceptJson, .xAppKey, .xAuthToken(accessToken)]
        
        return fetchFamilyStatisticsInfo(spec: spec, headers: headers)
    }
}
