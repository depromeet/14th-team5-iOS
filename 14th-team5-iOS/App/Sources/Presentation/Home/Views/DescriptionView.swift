//
//  DescriptionView.swift
//  App
//
//  Created by 마경미 on 21.04.24.
//

import UIKit

import Core
import Domain
import DesignSystem

import RxSwift
import RxCocoa
//
//fileprivate extension TimerType {
//    var title: String {
//        switch self {
//        case .standard: return "매일 12-24시에 사진 한 장을 올려요"
//        case .widget: return "위젯을 추가하면 더 빠르게 사진을 볼 수 있어요"
//        case .warning: return "시간이 얼마 남지 않았어요!"
//        case .allUploaded: return "우리 가족 모두가 사진을 올린 날"
//        }
//    }
//
//    var image: UIImage {
//        switch self {
//        case .standard: return DesignSystemAsset.smile.image
//        case .widget: return DesignSystemAsset.widget.image
//        case .warning: return DesignSystemAsset.fire.image
//        case .allUploaded: return DesignSystemAsset.congratulation.image
//        }
//    }
//
//    var timerTextColor: UIColor {
//        switch self {
//        case .warning: return .warningRed
//        default: return UIColor.white
//        }
//    }
//
//    var descTextColor: UIColor {
//        switch self {
//        case .warning: return .warningRed
//        default: return .gray300
//        }
//    }
//}

final class DescriptionView: BaseView<DescriptionReactor> {
    private let descriptionLabel: BibbiLabel = BibbiLabel(.body2Regular, textAlignment: .center, textColor: .gray300)
    private let imageView: UIImageView = UIImageView()
    
    let postTypeRelay: BehaviorRelay<PostType> = BehaviorRelay(value: .survival)
  
    override func bind(reactor: DescriptionReactor) {
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    override func setupUI() {
        addSubviews(descriptionLabel, imageView)
    }
    
    override func setupAutoLayout() {
        descriptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.height.equalTo(20)
            $0.centerX.equalToSuperview()
        }

        imageView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel)
            $0.size.equalTo(20)
            $0.leading.equalTo(descriptionLabel.snp.trailing).offset(2)
        }
    }
}

extension DescriptionView {
    private func bindInput(reactor: DescriptionReactor) {
        postTypeRelay
            .distinctUntilChanged()
            .map { Reactor.Action.setPostType($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: DescriptionReactor) {
        reactor.state.map { $0.description }
            .compactMap { $0 }
            .distinctUntilChanged()
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
