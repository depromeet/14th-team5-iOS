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
        nextButton.rx.tap
            .throttle(RxConst.throttleInterval, scheduler: Schedulers.main)
            .withUnretained(self)
            .bind(onNext: { $0.0.goToNextPage() })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.dateDesc }
            .withUnretained(self)
            .observe(on: Schedulers.main)
            .bind(onNext: { $0.0.setDescLabel(with: $0.1) })
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
    
    public override func setupAttributes() {
        super.setupAttributes()
        
        descLabel.do {
            $0.text = _Str.Nickname.desc
            $0.textColor = DesignSystemAsset.gray400.color
            $0.font = UIFont(font: DesignSystemFontFamily.Pretendard.regular, size: 16)
        }
        
        nextButton.do {
            $0.setTitle("계속", for: .normal)
            $0.titleLabel?.font = UIFont(font: DesignSystemFontFamily.Pretendard.semiBold, size: 16)
            $0.setTitleColor(DesignSystemAsset.black.color, for: .normal)
            $0.backgroundColor = DesignSystemAsset.mainGreen.color
            $0.layer.cornerRadius = 30
        }
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        
        descLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(nextButton.snp.top).offset(-10)
        }
        
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-10)
            $0.height.equalTo(56)
        }
    }
}

extension AccountSignUpViewController {
    private func setDescLabel(with desc: String?) {
        guard let desc else { return }
        descLabel.text = desc
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
