//
//  AccountSignUpViewController.swift
//  App
//
//  Created by geonhui Yu on 12/8/23.
//

import UIKit
import Core
import DesignSystem

fileprivate typealias _Str = AccountSignUpStrings
public final class AccountSignUpViewController: BasePageViewController<AccountSignUpReactor> {
    private let nextButton = UIButton()
    private let descLabel = UILabel()
    
    private var pages = [UIViewController]()
    private var initalPage = 0
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        setViewControllers([pages[initalPage]], direction: .forward, animated: true)
        isPagingEnabled = false
    }
    
    public override func bind(reactor: AccountSignUpReactor) {
        reactor.state.map { $0.nicknameButtonTappedFinish }
            .filter { $0 }
            .take(1)
            .withUnretained(self)
            .bind(onNext: { $0.0.goToNextPage() })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.dateButtonTappedFinish }
            .filter { $0 }
            .take(1)
            .withUnretained(self)
            .bind(onNext: { $0.0.goToNextPage() })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.profileButtonTappedFinish }
            .filter { $0 }
            .take(1)
            .withUnretained(self)
            .bind(onNext: { $0.0.showOnboardingViewCotnroller() })
            .disposed(by: disposeBag)
    }
    
    public override func setupUI() {
        super.setupUI()
        
        let nicknamePage = AccountNicknameViewController(reacter: reactor)
        let datePage = AccountDateViewController(reacter: reactor)
        let profilePage = AccountProfileViewController(reacter: reactor)
        
        pages.append(nicknamePage)
        pages.append(datePage)
        pages.append(profilePage)
        
        view.addSubviews(descLabel, nextButton)
    }
}

extension AccountSignUpViewController {
    private func goToNextPage() {
        guard let currentPage = viewControllers?[0],
              let nextPage = self.dataSource?.pageViewController(self, viewControllerAfter: currentPage) else { return }
        setViewControllers([nextPage], direction: .forward, animated: true)
    }
    
    private func showOnboardingViewCotnroller() {
        let onBoardingViewController = OnBoardingDIContainer().makeViewController()
        onBoardingViewController.modalPresentationStyle = .fullScreen
        present(onBoardingViewController, animated: true)
    }
}

extension AccountSignUpViewController: UIPageViewControllerDataSource {
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        
        guard currentIndex < pages.count - 1 else { return nil }
        return pages[currentIndex + 1]
    }
}
