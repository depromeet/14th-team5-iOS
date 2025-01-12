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
    
    private var pages = [UIViewController]()
    private var initalPage = 0
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        navigationBarView.isHidden = true
        setViewControllers([pages[initalPage]], direction: .forward, animated: true)
        isPagingEnabled = false
    }
    
    public override func bind(reactor: AccountSignUpReactor) {
        super.bind(reactor: reactor)
        
        navigationBarView.rx.leftButtonTap
            .observe(on: RxSchedulers.main)
            .withUnretained(self)
            .bind { $0.0.goToPrevPage() }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$dateButtonTappedFinish)
            .filter { $0 }
            .withUnretained(self)
            .bind(onNext: { $0.0.goToNextPage() })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$nicknameButtonTappedFinish)
            .filter { $0 }
            .withUnretained(self)
            .bind(onNext: { $0.0.goToNextPage() })
            .disposed(by: disposeBag)
    }
    
    public override func setupUI() {
        super.setupUI()
        
        let nicknamePage = AccountNicknameViewController(reactor: reactor)
        let datePage = AccountDateViewController(reactor: reactor)
        let profilePage = AccountProfileViewController(reactor: reactor)
        
        pages.append(nicknamePage)
        pages.append(datePage)
        pages.append(profilePage)
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        
        navigationBarView.do {
            $0.setNavigationView(leftItem: .arrowLeft, rightItem: .empty)
        }
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
    }
}

extension AccountSignUpViewController {
    private func goToNextPage() {
        guard let currentPage = viewControllers?[0],
              let nextPage = self.dataSource?.pageViewController(self, viewControllerAfter: currentPage) else { return }
        
        setViewControllers([nextPage], direction: .forward, animated: true)
    }
    
    private func goToPrevPage() {
        guard let currentPage = viewControllers?[0],
              let prevPage = self.dataSource?.pageViewController(self, viewControllerBefore: currentPage) else { return }
        
        setViewControllers([prevPage], direction: .reverse, animated: true)
    }
}

extension AccountSignUpViewController: UIPageViewControllerDataSource {
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }

        if currentIndex == 1 {
            navigationBarView.isHidden = true
        } else {
            navigationBarView.isHidden = false
        }
        
        guard currentIndex > 0 else { return nil }
        return pages[currentIndex - 1]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        
        navigationBarView.isHidden = false
        
        guard currentIndex < pages.count - 1 else { return nil }
        return pages[currentIndex + 1]
    }
}
