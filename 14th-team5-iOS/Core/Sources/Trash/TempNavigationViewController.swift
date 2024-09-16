//
//  TempNavigationViewController.swift
//  Core
//
//  Created by 김건우 on 9/15/24.
//


import UIKit

import SnapKit
import ReactorKit

/// 캘린더 화면 리팩토링 전까지 쓸 임시 뷰컨
open class TempNavigationViewController<R>: TempViewController<R> where R: Reactor {
    
    // MARK: - Typealias
    typealias Reactor = R
    
    // MARK: - Views
    
    public let navigationBar = BBNavigationBar()
    public let contentView = UIView()
    
    // MARK: - Properties
    
    /// 왼쪽 버튼이 특정 타입시, popViewController 기본 구현을 제공할 지 여부를 결정합니다.
    /// 기본값은 true입니다.
    public var enableAutoPopViewController = true
    
    // MARK: - Intitalizer
    public override init() {
        super.init()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycles
    open override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Helpers
    open override func bind(reactor: R) {
        super.bind(reactor: reactor)
        
        // 왼쪽 버튼이 특정 타입시, popViewController 기본 구현 제공
        navigationBar.rx.didTapLeftBarButton
            .bind(with: self) { owner, _ in
                let item = owner.navigationBar.leftBarButtonItem
                
                owner.popViewController(item)
            }
            .disposed(by: disposeBag)
    }
    
    open override func setupUI() {
        super.setupUI()
        
        view.addSubviews(navigationBar, contentView)
    }
    
    open override func setupAutoLayout() {
        super.setupAutoLayout()
        
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(42) // 내비게이션 바 기본 높이 42
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }

    }
    
    open override func setupAttributes() {
        super.setupAttributes()
        
        navigationBar.layer.zPosition = 888
    }
    
}


// MARK: - Extensions

extension TempNavigationViewController {
    
    /// NavigationBar의 높이를 바꿉니다.
    public func setNavigationBarHeight(_ height: CGFloat) {
        navigationBar.snp.updateConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(height)
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    
    /// NavigationBar를 View의 맨 앞으로 가져옵니다.
    /// contentView가 아닌 view에 새로운 UI를 배치할 때, 꼭 호출해주어야 합니다.
    @available(*, deprecated)
    public func bringNavigationBarViewToFront() {
        view.bringSubviewToFront(navigationBar)
    }
    
}


extension TempNavigationViewController {
    
    private func popViewController(_ ifTypeIsXMark: BBNavigationButtonStyle?) {
        if enableAutoPopViewController {
            switch ifTypeIsXMark {
            case .arrowLeft, .xmark:
                self.navigationController?.popViewController(animated: true)
            @unknown default:
                return
            }
        }
    }
    
}

