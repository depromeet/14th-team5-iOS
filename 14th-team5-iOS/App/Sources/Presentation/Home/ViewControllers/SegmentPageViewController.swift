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

enum PageChangeWay {
    case scroll
    case segmentTap
}

struct PageRelay {
    let way: PageChangeWay
    let index: Int
}

final class SegmentPageViewController: UIPageViewController {
    private let survivalViewController: MainPostViewController = MainPostViewControllerWrapper(type: .survival).makeViewController()
    private let missionViewController: MainPostViewController =  MainPostViewControllerWrapper(type: .mission).makeViewController()
    private let disposeBag = DisposeBag()
    
    private lazy var pages: [UIViewController] = [survivalViewController, missionViewController]
    
    let indexRelay: BehaviorRelay<PageRelay> = BehaviorRelay(value: .init(way: .segmentTap, index: 0))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        self.delegate = self
        
        setViewControllers([survivalViewController], direction: .forward, animated: true)
        bind()
    }
    
    private func bind() {
        indexRelay.filter { $0.way == .segmentTap }.map { $0.index }
            .distinctUntilChanged()
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind(onNext: {
                switch $0.1 {
                case 0: $0.0.setViewControllers([$0.0.survivalViewController], direction: .reverse, animated: true) { [weak self] _ in
                    self?.isPagingEnabled = true
                }
                case 1: $0.0.setViewControllers([$0.0.missionViewController], direction: .forward, animated: true) { [weak self] _ in
                    self?.isPagingEnabled = true
                }
                default:
                    fatalError("INDEX OUT OF RANGE")
                }
            })
            .disposed(by: disposeBag)
    }

}

extension SegmentPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController),
              index - 1 >= 0 else { return nil }
        
        return pages[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController),
              index + 1 != pages.count else { return nil }
        
        return pages[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            indexRelay.accept(.init(way: .scroll, index: currentIndex))
        }
    }
}
