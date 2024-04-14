//
//  BasePageViewController.swift
//  Core
//
//  Created by geonhui Yu on 12/24/23.
//

import UIKit
import DesignSystem

import ReactorKit
import RxSwift

open class BasePageViewController<R>: UIPageViewController, ReactorKit.View where R: Reactor {
    public typealias Reactor = R
    
    // MARK: - Properties
    public var disposeBag: RxSwift.DisposeBag = DisposeBag()
    public let navigationBarView: BibbiNavigationBarView = BibbiNavigationBarView()
    
    // MARK: - Intializer
    public init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    public convenience init(reacter: Reactor? = nil) {
        self.init()
        self.reactor = reacter
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
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    
    // MARK: - Helpers
    /// 리액터와 바인딩을 위한 메서드
    open func bind(reactor: R) { }
    
    /// 서브 뷰 추가를 위한 메서드
    open func setupUI() {
        view.addSubview(navigationBarView)
    }
    
    /// 오토레이아웃 설정을 위한 메서드
    open func setupAutoLayout() {
        navigationBarView.snp.makeConstraints {
            $0.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(42)
        }
    }
    
    /// 뷰의 속성 설정을 위한 메서드
    open func setupAttributes() {
        view.backgroundColor = .bibbiBlack
        navigationController?.navigationBar.isHidden = true
    }
}
