//
//  CalendarAPIWorker.swift
//  Data
//
//  Created by 김건우 on 12/21/23.
//

import Core
import Domain
import Foundation

import RxSwift

public typealias CalendarAPIWorker = CalendarAPIs.Worker
extension CalendarAPIs {
    public final class Worker: APIWorker {
        static let queue = {
            ConcurrentDispatchQueueScheduler(queue: DispatchQueue(label: "CalendarAPIQueue", qos: .utility))
        }()
        
        public override init() {
            super.init()
            self.id = "CalendarAPIWorker"
        }
    }
}

// MARK: - Extensions

extension CalendarAPIWorker {
    
    
    // MARK: - Fetch Calendar

    @available(*, deprecated)
    public func fetchCalendarResponse(yearMonth: String) -> Single<ArrayResponseCalendarResponseDTO?> {
        let spec = CalendarAPIs.calendarResponse(yearMonth).spec
        
        return request(spec: spec)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("CalendarResponse Fetch Result: \(str)")
                }
            }
            .map(ArrayResponseCalendarResponseDTO.self)
            .catchAndReturn(nil)
            .asSingle()
    }
    
    
    
    // MARK: - Fetch Statistics Summary
    
    public func fetchStatisticsSummary(yearMonth: String) -> Single<FamilyMonthlyStatisticsResponseDTO?> {
        let spec = CalendarAPIs.fetchStatisticsSummary(yearMonth).spec
        
        return request(spec: spec)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("StatisticsSummary Fetch Result: \(str)")
                }
            }
            .map(FamilyMonthlyStatisticsResponseDTO.self)
            .catchAndReturn(nil)
            .asSingle()
    }
    
    
    
    // MARK: - Fetch Monthly Calendar
    
    public func fetchMonthlyCalendar(yearMonth: String) -> Single<ArrayResponseMonthlyCalendarResponseDTO?> {
        let spec = CalendarAPIs.fetchMonthlyCalendar(yearMonth).spec
        
        return request(spec: spec)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("MonthlyCalendar Fetch Result: \(str)")
                }
            }
            .map(ArrayResponseMonthlyCalendarResponseDTO.self)
            .catchAndReturn(nil)
            .asSingle()
    }
    
    
    
    // MARK: - Fetch Daily Calendar
    
    public func fetchDailyCalendar(yearMonthDay: String) -> Single<ArrayResponseDailyCalendarResponseDTO?> {
        let spec = CalendarAPIs.fetchDailyCalendar(yearMonthDay).spec
        
        return request(spec: spec)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("DailyCalendar Fetch Result: \(str)")
                }
            }
            .map(ArrayResponseDailyCalendarResponseDTO.self)
            .catchAndReturn(nil)
            .asSingle()
    }
    
    
    
    
    // MARK: - Fetch Banner
    
    public func fetchCalendarBanner(yearMonth: String) -> Single<BannerResponseDTO?> {
        let spec = CalendarAPIs.fetchBanner(yearMonth).spec
        
        return request(spec: spec)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("Banner Fetch Result: \(str)")
                }
            }
            .map(BannerResponseDTO.self)
            .catchAndReturn(nil)
            .asSingle()
    }
    
}
