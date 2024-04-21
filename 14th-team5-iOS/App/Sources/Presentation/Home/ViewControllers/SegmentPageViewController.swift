//
//  SegmentPageViewController.swift
//  App
//
//  Created by 마경미 on 21.04.24.
//

import UIKit

final class SegmentPageViewController: UIPageViewController {

    private let survivalViewController: SurvivalViewController = SurvivalDIContainer().makeViewController()
    private let missionViewController: MissionViewController = MissionViewController()
    
    private lazy var pages: [UIViewController] = [survivalViewController, missionViewController]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        self.delegate = self
        
        setViewControllers([survivalViewController], direction: .forward, animated: true)
    }
    

}

extension SegmentPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController), currentIndex > 0 else {
            return nil
        }
        return pages[currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController), currentIndex < pages.count - 1 else {
            return nil
        }
        return pages[currentIndex + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let currentViewController = pageViewController.viewControllers?.first,
               let currentIndex = pages.firstIndex(of: currentViewController) {
                print("현재 페이지: \(currentIndex)")
            }
        }
    }
}
