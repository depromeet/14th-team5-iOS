//
//  ProfileFeedPageViewController.swift
//  App
//
//  Created by Kim dohyun on 5/4/24.
//

import UIKit

import Core
import RxSwift
import ReactorKit
import RxCocoa

final class ProfileFeedPageViewController: UIPageViewController {
    var disposeBag: DisposeBag = DisposeBag()
    
    
    private lazy var feedViewControllers:[UIViewController] = [profileFeedSurivalViewController, profileFeedMissionViewController]
    public var memberId: String
    
    private lazy var profileFeedSurivalViewController: ProfileFeedViewController = ProfileFeedViewControllerWrapper(postType: .survival, memberId: memberId).viewController
    private lazy var profileFeedMissionViewController: ProfileFeedViewController = ProfileFeedViewControllerWrapper(postType: .mission, memberId: memberId).viewController
    

    
    init(reactor: ProfileFeedPageViewReactor, memberId: String) {
        self.memberId = memberId
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        setupUI()
    }
    
    private func setupUI() {
        setViewController(index: 0)
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



extension ProfileFeedPageViewController: ReactorKit.View {
    
    func bind(reactor: ProfileFeedPageViewReactor) {
        reactor.state
            .map { $0.pageType == .survival ? 0 : 1 }
            .distinctUntilChanged()
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind { owner, index in
                owner.setViewController(index: index)
            }.disposed(by: disposeBag)
    }
}



extension ProfileFeedPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = feedViewControllers.firstIndex(of: viewController),
                      index - 1 >= 0 else {
            BBLogManager.sendError(error: BBCrashError.indexOutBounds)
            return nil
        }
        return feedViewControllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = feedViewControllers.firstIndex(of: viewController),
              index + 1 != feedViewControllers.count else {
            BBLogManager.sendError(error: BBCrashError.indexOutBounds)
            return nil
        }

        return feedViewControllers[index + 1]
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let currentViewController = pageViewController.viewControllers?.first,
              let currentIndex = feedViewControllers.firstIndex(of: currentViewController) else {
            BBLogManager.sendError(error: BBCrashError.indexOutBounds)
            return
        }
        reactor?.action.onNext(.updatePageViewController(currentIndex))
    }
    
}
