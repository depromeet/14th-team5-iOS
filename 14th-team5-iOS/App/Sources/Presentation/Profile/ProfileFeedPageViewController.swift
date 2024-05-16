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

    
    public var currentPageRelay: BehaviorRelay<Int> = .init(value: 0) {
        didSet {
            setViewController(index: currentPageRelay.value)
        }
    }
    
    private lazy var feedViewControllers:[UIViewController] = [profileFeedSurivalViewController, profileFeedMissionViewController]
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
        self.delegate = self
        self.dataSource = self
    }
    
    private func setupUI() {
        setViewController(index: currentPageRelay.value)
    }
    
    
    private func setViewController(index: Int) {
        switch index {
        case 0:
            setViewControllers([profileFeedSurivalViewController], direction: .reverse, animated: true) { [weak self] _ in
                self?.isPagingEnabled = true
            }
        case 1:
            setViewControllers([profileFeedMissionViewController], direction: .forward, animated: true) { [weak self] _ in
                self?.isPagingEnabled = true
            }
        default:
            break
        }
    }
}





extension ProfileFeedPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = feedViewControllers.firstIndex(of: viewController),
                      index - 1 >= 0 else { return nil }
        return feedViewControllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = feedViewControllers.firstIndex(of: viewController),
                      index + 1 != feedViewControllers.count else { return nil }
        return feedViewControllers[index + 1]
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = feedViewControllers.firstIndex(of: currentViewController) {
            currentPageRelay.accept(currentIndex)
        }
    }
    
}
