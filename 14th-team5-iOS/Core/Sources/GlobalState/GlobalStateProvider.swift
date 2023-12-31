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
}

final public class GlobalStateProvider: GlobalStateProviderProtocol {
    lazy public var activityGlobalState: ActivityGlobalStateType = ActivityGlobalState(provider: self)
    lazy public var calendarGlabalState: CalendarGlobalStateType = CalendarGlobalState(provider: self)
    
    public init() { }
}
