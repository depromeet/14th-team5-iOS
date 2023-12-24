//
//  AccountSignUpViewController.swift
//  App
//
//  Created by geonhui Yu on 12/8/23.
//

import UIKit
import Core
import DesignSystem

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
    }
    
    public override func setupUI() {
        super.setupUI()
        
        let nicknamePage = AccountNicknameViewController(reacter: reactor)
        let datePage = AccountDateViewController()
        let profilePage = AccountProfileViewController(reacter: reactor)
        
        pages.append(nicknamePage)
        pages.append(datePage)
        pages.append(profilePage)
        
        view.addSubviews(descLabel, nextButton)
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        
        descLabel.text = "가족에게 주로 불리는 호칭을 입력해주세요"
        descLabel.textColor = DesignSystemAsset.gray400.color
        descLabel.font = UIFont(font: DesignSystemFontFamily.Pretendard.regular, size: 16)
        
        nextButton.setTitle("계속", for: .normal)
        nextButton.tintColor = DesignSystemAsset.black.color
        nextButton.backgroundColor = DesignSystemAsset.mainGreen.color
        nextButton.layer.cornerRadius = 30
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
    private func goToNextPage() {
        guard let currentPage = viewControllers?[0],
              let nexPage = self.dataSource?.pageViewController(self, viewControllerAfter: currentPage) else { return }
        
        setViewControllers([nexPage], direction: .forward, animated: true)
        updateButtonType(isActive: false)
    }
    
    private func updateButtonType(isActive: Bool) {
        nextButton.isEnabled = !isActive
        nextButton.backgroundColor = isActive ? DesignSystemAsset.mainGreen.color : DesignSystemAsset.mainGreenHover.color.withAlphaComponent(0.2)
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


