//
//  GlobalStateProvider.swift
//  Core
//
//  Created by 김건우 on 12/9/23.
//

import Foundation

public protocol GlobalStateProviderProtocol: AnyObject {
    var activityGlobalState: ActivityGlobalStateType { get }
    var calendarGlabalState: CalendarGlobalStateType { get }
    var toastGlobalState: ToastGlobalStateType { get }
}

final public class GlobalStateProvider: GlobalStateProviderProtocol {
    public lazy var activityGlobalState: ActivityGlobalStateType = ActivityGlobalState(provider: self)
    public lazy var calendarGlabalState: CalendarGlobalStateType = CalendarGlobalState(provider: self)
    public lazy var toastGlobalState: ToastGlobalStateType = ToastGlobalState(provider: self)
    
    public init() { }
}
