//
//  BaseViewController.swift
//  Core
//
//  Created by 김건우 on 11/29/23.
//

import UIKit
import DesignSystem

import ReactorKit
import RxSwift

@available(*, deprecated, renamed: "ReactorViewController")
open class BaseViewController<R>: UIViewController, ReactorKit.View where R: Reactor {
    public typealias Reactor = R
    
    // MARK: - Properties
    public var disposeBag: RxSwift.DisposeBag = DisposeBag()
    public let navigationBarView: BibbiNavigationBarView = BibbiNavigationBarView()
    
    // MARK: - Intializer
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    public convenience init(reactor: Reactor? = nil) {
        self.init()
        self.reactor = reactor
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycles
    override open func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAutoLayout()
        setupAttributes()
    }
    
    // MARK: - Helpers
    /// 리액터와 바인딩을 위한 메서드
    open func bind(reactor: R) {
        navigationBarView.rx.leftButtonTap
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: {
                switch $0.1 {
                case .arrowLeft:
                    self.navigationController?.popViewController(animated: true)
                case .xmark:
                    self.navigationController?.popViewController(animated: true)
                    //                    self.dismiss(animated: true) { self.dismissCompletion() }
                default: break
                }
            })
            .disposed(by: disposeBag)
    }
    
    /// 서브 뷰 추가를 위한 메서드
    open func setupUI() {
        view.addSubview(navigationBarView)
    }
    
    /// 오토레이아웃 설정을 위한 메서드
    open func setupAutoLayout() {
        navigationBarView.snp.makeConstraints {
            $0.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(52)
        }
    }
    
    /// 뷰의 속성 설정을 위한 메서드
    open func setupAttributes() {
        view.backgroundColor = .bibbiBlack
        navigationController?.navigationBar.isHidden = true
    }
    
    open func dismissCompletion() { }
}
