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

public class WebContentViewController: BaseViewController<WebContentViewReactor> {
    
    private let webView: WKWebView = WKWebView()
    private let webViewIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
    
    public override func loadView() {
        view = webView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func setupUI() {
        super.setupUI()
        view.addSubviews(webViewIndicatorView)
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        
        webViewIndicatorView.do {
            $0.hidesWhenStopped = true
            $0.color = .gray
        }
        
    }
    
    
    public override func bind(reactor: WebContentViewReactor) {

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
