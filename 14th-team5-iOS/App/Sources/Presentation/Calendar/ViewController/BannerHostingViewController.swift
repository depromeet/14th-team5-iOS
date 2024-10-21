//
//  BannerViewController.swift
//  App
//
//  Created by 김건우 on 10/16/24.
//

import SwiftUI

import Then

final class BannerHostingViewController: UIHostingController<BannerView> {
    
    private let _viewModel: BannerViewModel
    
    init(reactor: MemoriesCalendarPageReactor?) {
        self._viewModel = BannerViewModel(reactor: reactor, state: .init())
        super.init(rootView: BannerView(viewModel: _viewModel))
        
        self.view.backgroundColor = UIColor.clear
    }
    
    @MainActor @preconcurrency required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var viewModel: BannerViewModel {
        get { _viewModel }
        set { }
    }
    
    func updateState(_ state: BannerViewModel.State) {
        viewModel.updateState(state: state)
    }
    
}
