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
    func fetchMonthlyCalendar(_ yearMonth: String, accessToken: String) -> Single<ArrayResponseCalendarResponse?> {
        let spec = CalendarAPIs.monthlyCalendar(yearMonth: yearMonth).spec
        let headers: [BibbiHeader] = [.acceptJson, .xAuthToken(accessToken)]
        return request(spec: spec, headers: headers)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("MonthlyCalendar Fetch Result: \(str)")
                }
            }
            .map(ArrayResponseCalendarResponseDTO.self)
            .catchAndReturn(nil)
            .map { $0?.toDomain() }
            .asSingle()
    }
    
    func fetchWeeklyCalendar(_ yearMonth: String, week: Int, accessToken: String) -> Single<ArrayResponseCalendarResponse?> {
        let spec = CalendarAPIs.weeklyCalendar(yearMonth: yearMonth, week: week).spec
        let headers: [BibbiHeader] = [.acceptJson, .xAuthToken(accessToken)]
        return request(spec: spec, headers: headers)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("WeeklyCalendar Fetch Result: \(str)")
                }
            }
            .map(ArrayResponseCalendarResponseDTO.self)
            .catchAndReturn(nil)
            .map { $0?.toDomain() }
            .asSingle()
    }
}
