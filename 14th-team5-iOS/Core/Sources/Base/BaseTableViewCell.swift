//
//  BaseTableViewCell.swift
//  Core
//
//  Created by 김건우 on 11/29/23.
//

import UIKit

import ReactorKit
import RxSwift

open class BaseTableViewCell<R>: UITableViewCell, ReactorKit.View where R: Reactor {
    public typealias Reactor = R
    
    // MARK: - Properties
    public var disposeBag: RxSwift.DisposeBag = DisposeBag()
    
    // MARK: - Intializer
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        intialize()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Helpers
    // 셀 초기화를 위한 메서드
    open func intialize() { }
    
    // 리액터와 바인딩을 위한 메서드
    open func bind(reactor: R) { }
    
    // 오토레이아웃 설정을 위한 메서드
    open func setupAutoLayout() { }
    
    // 뷰의 속성 설정을 위한 메서드
    open func setupAttributes() { }
}
