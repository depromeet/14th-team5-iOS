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
    
    private let navigationBar: BibbiNavigationBarView = BibbiNavigationBarView()
    private let nextButton = UIButton()
    
    private var pages = [UIViewController]()
    private var initalPage = 0
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        setViewControllers([pages[initalPage]], direction: .forward, animated: true)
        isPagingEnabled = false
        navigationBar.isHidden = true
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    public override func bind(reactor: AccountSignUpReactor) {
        navigationBar.rx
            .didTapLeftBarButton
            .observe(on: Schedulers.main)
            .throttle(.milliseconds(300), scheduler: Schedulers.main)
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
        
        view.addSubviews(navigationBar)
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        
        navigationBar.do {
            $0.leftBarButtonItem = .arrowLeft
            $0.leftBarButtonItemTintColor = .gray300
        }
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(42)
        }
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
    
    private func showOnboardingViewCotnroller() {
        let onBoardingViewController = OnBoardingDIContainer().makeViewController()
        onBoardingViewController.modalPresentationStyle = .fullScreen
        present(onBoardingViewController, animated: true)
    }
}

extension AccountSignUpViewController: UIPageViewControllerDataSource {
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }

        if currentIndex == 1 {
            navigationBar.isHidden = true
        } else {
            navigationBar.isHidden = false
        }
        
        guard currentIndex > 0 else { return nil }
        return pages[currentIndex - 1]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        
        navigationBar.isHidden = false
        
        guard currentIndex < pages.count - 1 else { return nil }
        return pages[currentIndex + 1]
    }
}
