//
//  SegmentPageViewController.swift
//  App
//
//  Created by 마경미 on 21.04.24.
//

import UIKit

import Domain

import RxSwift
import RxCocoa

final class SegmentPageViewController: UIPageViewController {
    private let survivalViewController: MainPostViewController = MainPostViewDIContainer().makeViewController(type: .survival)
    private let missionViewController: MainPostViewController = MainPostViewDIContainer().makeViewController(type: .mission)
    private let disposeBag = DisposeBag()
    
    private lazy var pages: [UIViewController] = [survivalViewController, missionViewController]
    
    let indexRelay: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        self.delegate = self
        
        setViewControllers([survivalViewController], direction: .forward, animated: true)
        bind()
    }
    
    private func bind() {
        indexRelay
            .withUnretained(self)
            .bind(onNext: {
                switch $0.1 {
                case 0:
                    $0.0.setViewControllers([$0.0.survivalViewController], direction: .reverse, animated: true)
                case 1:
                    $0.0.setViewControllers([$0.0.missionViewController], direction: .forward, animated: true)
                default:
                    fatalError("INDEX OUT OF RANGE")
                }
            })
            .disposed(by: disposeBag)
    }

}

extension SegmentPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
//    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
//        if completed {
//            if let currentViewController = pageViewController.viewControllers?.first,
//               let currentIndex = pages.firstIndex(of: currentViewController) {
//                print("현재 페이지: \(currentIndex)")
//            }
//        }
//    }
}
