//
//  WebContentViewController.swift
//  App
//
//  Created by Kim dohyun on 12/31/23.
//

import UIKit
import WebKit

import Core
import Then
import RxSwift
import RxCocoa
import ReactorKit

public class WebContentViewController: BaseViewController<WebContentReactor> {
    
    private let webView: WKWebView = WKWebView()
    private let webViewIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func setupUI() {
        super.setupUI()
        view.addSubviews(webView, webViewIndicatorView)
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        
        
        navigationBarView.do {
            $0.setNavigationView(leftItem: .arrowLeft, rightItem: .empty)
        }
        
        webViewIndicatorView.do {
            $0.hidesWhenStopped = true
            $0.color = .gray
        }
        
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        webViewIndicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        webView.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
        
    }
    
    
    public override func bind(reactor: WebContentReactor) {
        super.bind(reactor: reactor)

        Observable.just(())
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.url }
            .bind(to: webView.rx.loadURL)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isLoading }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            .drive(webViewIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
    }
}
