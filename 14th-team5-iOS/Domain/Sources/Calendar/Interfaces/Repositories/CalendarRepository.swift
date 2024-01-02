//
//  CalendarRepository.swift
//  Domain
//
//  Created by 김건우 on 12/29/23.
//

import Foundation

import RxSwift

public protocol CalendarRepositoryProtocol {
    var disposeBag: DisposeBag { get }
    
    func fetchMonthlyCalendar(_ yearMonth: String) -> Observable<ArrayResponseCalendarResponse?>
    func fetchWeeklyCalendar(_ yearMonth: String, week: Int) -> Observable<ArrayResponseCalendarResponse?>
}
