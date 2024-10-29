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

typealias CalendarAPIWorker = CalendarAPIs.Worker
extension CalendarAPIs {
    final class Worker: BBRxAPIWorker { }
}

// MARK: - Extensions

extension CalendarAPIWorker {
    
    // MARK: - Fetch Banner Info
    
    public func fetchCalendarBanner(yearMonth: String) -> Observable<BannerResponseDTO> {
        let spec = CalendarAPIs.fetchBannerInfo(yearMonth).spec
        
        return request(spec)
    }
    
    // MARK: - Fetch Statistics Summary
    
    public func fetchStatisticsSummary(yearMonth: String) -> Observable<FamilyMonthlyStatisticsResponseDTO> {
        let spec = CalendarAPIs.fetchStatisticsSummary(yearMonth).spec
        
        return request(spec)
    }
    
    
    
    // MARK: - Fetch Monthly Calendar
    
    public func fetchMonthlyCalendar(yearMonth: String) -> Observable<ArrayResponseMonthlyCalendarResponseDTO> {
        let spec = CalendarAPIs.fetchMonthlyCalendar(yearMonth).spec
        
        return request(spec)
    }
    
    
    
    // MARK: - Fetch Daily Calendar
    
    public func fetchDailyCalendar(yearMonthDay: String) -> Observable<ArrayResponseDailyCalendarResponseDTO> {
        let spec = CalendarAPIs.fetchDailyCalendar(yearMonthDay).spec
        
        return request(spec)
    }
    
}
