//
//  BannerViewModel.swift
//  App
//
//  Created by 김건우 on 1/26/24.
//

import Core
import SwiftUI

public final class BannerViewModel: BaseViewModel<MemoriesCalendarPageReactor, BannerViewModel.State> {
    
    // MARK: - Properties
    
    @Published var shimmeringActive: Bool = true
    
    // MARK: - State
    
    public struct State: ViewModelState {
        var familyTopPercentage: Int = 0
        var allFamilyMemberUploadedDays: Int = 0
        var bannerImage: UIImage?
        var bannerString: String?
        var bannerColor: UIColor?
    }
    
    // MARK: - Action
    
    func onEvent(action: MemoriesCalendarPageReactor.Action) {
        reactor?.action.onNext(action)
    }
    
    func updateState(state: State) {
        self.state = state
        self.shimmeringActive = false
    }
}
