//
//  ProfileViewController.swift
//  App
//
//  Created by Kim dohyun on 12/17/23.
//

import UIKit

import Core
import RxSwift
import RxCocoa
import ReactorKit
import SnapKit
import Then


public final class ProfileViewController: BaseViewController<ProfileViewReactor> {
    //MARK: Views
    private let profileIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
    private let profileViewReactor: BibbiProfileViewReactor = BibbiProfileViewReactor()
    private lazy var profileView: BibbiProfileView = BibbiProfileView(cornerRadius: 60, reactor: profileViewReactor)
    private let profileTitleView: UILabel = UILabel()
    private let profileFeedCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func setupUI() {
        super.setupUI()
        view.addSubviews(profileView, profileFeedCollectionView, profileIndicatorView)
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        
        profileTitleView.do {
            $0.textColor = .white
            $0.text = "활동"
        }
        
        navigationItem.do {
            $0.titleView = profileTitleView
            
        }
        
        profileIndicatorView.do {
            $0.hidesWhenStopped = true
            $0.color = .gray
        }
        
        profileFeedCollectionView.do {
            $0.register(ProfileFeedCollectionViewCell.self, forCellWithReuseIdentifier: "ProfileFeedCollectionViewCell")
            $0.showsVerticalScrollIndicator = true
            $0.showsHorizontalScrollIndicator = false
            $0.backgroundColor = .clear
        }
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        
        profileView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(200)
        }
        
        profileFeedCollectionView.snp.makeConstraints {
            $0.top.equalTo(profileView.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
        
        profileIndicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    
    public override func bind(reactor: ProfileViewReactor) {

        Observable.just(())
            .map { Reactor.Action.viewDidLoad}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        reactor.state
            .map { $0.isLoading }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            .drive(profileIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
    }
}
