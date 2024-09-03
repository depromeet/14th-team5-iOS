//
//  ReactorViewController.swift
//  Core
//
//  Created by 김건우 on 6/5/24.
//

import DesignSystem
import UIKit

import ReactorKit
import RxSwift

open class ReactorViewController<R>: UIViewController, ReactorKit.View where R: Reactor {
    
    // MARK: - Typealias
    public typealias Reactor = R
    
    // MARK: - Properties
    private var initialReactor: Reactor?
    public var disposeBag: RxSwift.DisposeBag = DisposeBag()
    
    // MARK: - Intializer
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    public convenience init(reactor: Reactor? = nil) {
        self.init()
        self.initialReactor = reactor
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
        setupReactor()
    }
    
    // MARK: - Helpers
    open func bind(reactor: R) { }
    
    open func setupUI() { }
    
    open func setupAutoLayout() { }
    
    open func setupAttributes() {
        view.backgroundColor = .bibbiBlack
    }
    
    open func setupReactor() {
        if let reactor = initialReactor {
            self.reactor = reactor
        }
    }
}
