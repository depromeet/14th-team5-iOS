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
    
    // MARK: - Helpers
    /// 리액터와 바인딩을 위한 메서드
    open func bind(reactor: R) { }
    
    /// 서브 뷰 추가를 위한 메서드
    open func setupUI() { }
    
    /// 오토레이아웃 설정을 위한 메서드
    open func setupAutoLayout() { }
    
    /// 뷰의 속성 설정을 위한 메서드
    open func setupAttributes() {
        // assets 정해지면 바꿀게요.
        view.backgroundColor = DesignSystemAsset.black.color
    }
}
