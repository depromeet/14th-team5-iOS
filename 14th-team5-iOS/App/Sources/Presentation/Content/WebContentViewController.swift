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
    private let webNavigationBar: BibbiNavigationBarView = BibbiNavigationBarView()
    private let webViewIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func setupUI() {
        super.setupUI()
        view.addSubviews(webView, webNavigationBar, webViewIndicatorView)
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        
        
        webNavigationBar.do {
            $0.navigationTitle = "약관 및 정책"
            $0.leftBarButtonItem = .arrowLeft
            $0.leftBarButtonItemTintColor = .gray300
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
        
        webNavigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(42)
        }
        
        webView.snp.makeConstraints {
            $0.top.equalTo(webNavigationBar.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
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
        
        webNavigationBar.rx
            .didTapLeftBarButton
            .throttle(.microseconds(300), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isLoading }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            .drive(webViewIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
    }
}
