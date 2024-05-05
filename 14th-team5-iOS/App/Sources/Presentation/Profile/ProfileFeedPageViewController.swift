//
//  ProfileFeedPageViewController.swift
//  App
//
//  Created by Kim dohyun on 5/4/24.
//

import UIKit

import Core
import RxSwift
import RxCocoa

final class ProfileFeedPageViewController: UIPageViewController {

    
    public var currentPage: Int = 0 {
        didSet {
            setViewController(index: currentPage)
        }
    }
    
    public var memberId: String = ""
    
    private lazy var profileFeedSurivalViewController: ProfileFeedViewController = ProfileFeedDIContainer(postType: .survival, memberId: memberId).makeViewController()
    private lazy var profileFeedMissionViewController: ProfileFeedViewController = ProfileFeedDIContainer(postType: .mission, memberId: memberId).makeViewController()
    

    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        setViewController(index: currentPage)
    }
    
    
    private func setViewController(index: Int) {
        switch index {
        case 0:
            setViewControllers([profileFeedSurivalViewController], direction: .reverse, animated: true)
        case 1:
            setViewControllers([profileFeedMissionViewController], direction: .forward, animated: true)
        default:
            break
        }
    }
}




