//
//  GlobalStateProvider.swift
//  Core
//
//  Created by 김건우 on 12/9/23.
//

import Foundation

public protocol ServiceProviderProtocol: AnyObject {
    
    var alertService: AlertServiceType { get }
    var bbAlertService: BBAlertServiceType { get }
    var bbToastService: BBToastServiceType { get }
    
    var calendarService: CalendarServiceType { get }
    var mainService: MainServiceType { get }
    var managementService: ManagementServiceType { get }
    
    var postGlobalState: PostGlobalStateType { get }
    var timerGlobalState: TimerGlobalStateType { get }
    var realEmojiGlobalState: RealEmojiGlobalStateType { get }
    var profilePageGlobalState: ProfileFeedGlobalStateType { get }
}

final public class ServiceProvider: ServiceProviderProtocol {
    
    public lazy var alertService: any AlertServiceType = AlertService(provider: self)
    public lazy var bbAlertService: any BBAlertServiceType = BBAlertService(provider: self)
    public lazy var bbToastService: any BBToastServiceType = BBToastService(provider: self)
    
    public lazy var calendarService: CalendarServiceType = CalendarService(provider: self)
    public lazy var mainService: MainServiceType = MainService(provider: self)
    public lazy var managementService: any ManagementServiceType = ManagementService(provider: self)
    
    public lazy var postGlobalState: PostGlobalStateType = PostGlobalState(provider: self)
    public lazy var timerGlobalState: TimerGlobalStateType = TimerGlobalState(provider: self)
    public lazy var realEmojiGlobalState: RealEmojiGlobalStateType = RealEmojiGlobalState(provider: self)
    public lazy var profilePageGlobalState: ProfileFeedGlobalStateType = ProfileFeedGlobalState(provider: self)
    
    public init() { }
}
