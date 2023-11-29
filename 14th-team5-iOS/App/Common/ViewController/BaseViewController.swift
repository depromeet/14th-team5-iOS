//
//  BaseViewController.swift
//  App
//
//  Created by 김건우 on 11/29/23.
//

import UIKit

import ReactorKit
import RxSwift

open class BaseViewController<T>: UIViewController, ReactorKit.View where T: Reactor {
    public typealias Reactor = T
    
    // MARK: - Properties
    public var disposeBag: RxSwift.DisposeBag = DisposeBag()
    
    // MARK: - Intializer
    public init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = UIColor.systemBackground
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
    // 리액터와 바인딩을 위한 메서드
    open func bind(reactor: T) { }
    
    // 서브 뷰 추가를 위한 메서드
    open func setupUI() { }
    
    // 오토레이아웃 설정을 위한 메서드
    open func setupAutoLayout() { }
    
    // 뷰의 속성 설정을 위한 메서드
    open func setupAttributes() { }
}




