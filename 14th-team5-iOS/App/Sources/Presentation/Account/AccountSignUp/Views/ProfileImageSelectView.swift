//
//  ProfileImageSelectView.swift
//  App
//
//  Created by geonhui Yu on 12/9/23.
//

import UIKit
import Core

import RxDataSources
import RxCocoa
import RxSwift
import SnapKit
import Then

final class ProfileImageSelectView: BaseView<ProfileImageSelctReactor> {
    private enum Metric {
        static let borderWidth: CGFloat = 2
    }
    
    // MARK: SubViews
    private let profileImageView = UIButton()
    private let completeButton = UIButton()
    
    // MARK: LifeCycles
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func bind(reactor: ProfileImageSelctReactor) {
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: ProfileImageSelctReactor) {
        profileImageView.rx.tap
            .throttle(.seconds(300), scheduler: MainScheduler.instance) // 변경할게요 ~
            .map { Reactor.Action.setProfileImage }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: ProfileImageSelctReactor) {
        reactor.state.map { $0.selectedProfileImage }
            .withUnretained(self)
            .bind(onNext: { $0.0.setProfileImage($0.1) })
            .disposed(by: disposeBag)
    }
    
    override func setupUI() {
        
    }
    
    override func setupAutoLayout() {
        
    }
    
    override func setupAttributes() {
        addSubviews(profileImageView, completeButton)
    }
}

fileprivate extension ProfileImageSelectView {
    func setProfileImage(_ profileImage: UIImage?) {
        guard let profileImage else { return }
        profileImageView.setImage(profileImage, for: .normal)
        profileImageView.layer.borderWidth = Metric.borderWidth
    }
}
