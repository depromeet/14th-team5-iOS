//
//  SegmentPageViewController.swift
//  App
//

import UIKit

import Core
import Domain

import RxSwift
import RxCocoa

struct FeedTransition {
    let to: BibbiFeedType
    let from: BibbiFeedType
}

final class SegmentPageViewController: UIPageViewController {

    // MARK: - Children
    private let survivalVC = MainPostViewControllerWrapper(type: .survival).makeViewController()
    private let missionVC  = MainPostViewControllerWrapper(type: .mission ).makeViewController()
    private let studioVC   = StudioPageViewControllerWrapper().makeViewController()

    internal lazy var pages: [UIViewController] = [survivalVC, missionVC, studioVC]
    internal let currentFeed = BehaviorRelay<BibbiFeedType>(value: .survival)
    internal let feedSelection = PublishRelay<BibbiFeedType>()

    private let disposeBag = DisposeBag()

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate   = self

        setViewControllers([survivalVC], direction: .forward, animated: false)
        bind()
    }
    
    private func bind() {
        feedSelection
            .asDriver(onErrorDriveWith: .empty())
            .withLatestFrom(currentFeed.asDriver()) { target, current in
                FeedTransition(to: target, from: current)
            }
            .distinctUntilChanged { $0.to == $1.to }
            .drive(rx.setFeedPage)
            .disposed(by: disposeBag)
    }

    internal var isPageScrollEnabled: Bool {
        get { pageScrollView?.isScrollEnabled ?? true }
        set { pageScrollView?.isScrollEnabled = newValue }
    }

    private var pageScrollView: UIScrollView? {
        view.subviews.compactMap { $0 as? UIScrollView }.first
    }
}

extension Reactive where Base: SegmentPageViewController {
    var currentFeed: Driver<BibbiFeedType> {
        base.currentFeed.asDriver()
    }
    
    var setFeedPage: Binder<FeedTransition> {
        Binder(base) { vc, tr in
            guard tr.to != tr.from,
                  let targetVC = vc.pages[safe: tr.to.index] else { return }

            let direction: UIPageViewController.NavigationDirection =
                tr.to.index > tr.from.index ? .forward : .reverse

            vc.isPageScrollEnabled = false
            vc.setViewControllers([targetVC], direction: direction, animated: true) { [weak vc] completed in
                guard let vc = vc else { return }
                if completed { vc.currentFeed.accept(tr.to) }
                vc.isPageScrollEnabled = true
            }
        }
    }
}

extension SegmentPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let idx = pages.firstIndex(of: viewController), idx - 1 >= 0 else { return nil }
        return pages[idx - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let idx = pages.firstIndex(of: viewController), idx + 1 < pages.count else { return nil }
        return pages[idx + 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        guard completed,
              let currentVC = pageViewController.viewControllers?.first,
              let idx = pages.firstIndex(of: currentVC),
              let feed = BibbiFeedType(index: idx) else { return }
        currentFeed.accept(feed)
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
