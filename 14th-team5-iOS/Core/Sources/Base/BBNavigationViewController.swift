//
//  BBNavigationViewController.swift
//  Core
//
//  Created by 김건우 on 6/5/24.
//

import UIKit

import SnapKit
import ReactorKit

/// 삐삐 스타일의 NavigationBar가 기본으로 포함되어 있는 ViewController입니다.
///
/// 이 ViewController는 ReactorViewController를 상속하고 있으며, bind() 메서드또한 제공합니다.
///
/// 이 ViewController를 상속하는 ViewController는 `View`가 아닌 `ContentView`에 UI를 배치해야 합니다. 
/// `ContentView`는 NavigationBar 영역을 제외한 나머지 공간을 차지하는 View입니다. 이 View는 NavigationBar의 높이에 따라 동적으로 변합니다.
///  물론 `ContentView`가 아니라 `View`에 UI를 배치해도 상관없습니다.
///
/// 삐삐 스타일의 NavigationBar의 UI나 스타일을 변경해야 한다면, 직접 관련 메서드나 프로퍼티를 통해 변경할 수 있습니다.
/// 가령, NavigationBar의 높이를 바꿔야 한다면. `setNavigationBarHeight(_:)` 메서드를 호출하면 됩니다.
///
/// LeftBarButton의 타입이 .arrowLeft나 .xmark라면 popViewController() 구현이 기본으로 제공됩니다. 
/// 왼쪽, 오른쪽 버튼의 동작을 정의하고 싶다면 `navigationBarView.rx.didTapRightButton`과 같이 정의하면 됩니다.
///
/// - NOTE: BBNavigationBarView의 스타일 변경을 위해 미리 정의된 편리한 메서드는 해당 뷰의 퀵헬프를 참조해주세요.
///
open class BBNavigationViewController<R>: ReactorViewController<R> where R: Reactor {
    
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

extension BBNavigationViewController {
    
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


extension BBNavigationViewController {
    
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
