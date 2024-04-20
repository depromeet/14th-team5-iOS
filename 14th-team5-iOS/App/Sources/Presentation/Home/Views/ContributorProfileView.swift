//
//  ProfileView.swift
//  App
//
//  Created by 마경미 on 05.12.23.
//

import UIKit
import Core
import Domain

import Kingfisher
import RxSwift

final class ContributorProfileView: UIView {
    private let nameLabel = BibbiLabel(.body2Bold, textAlignment: .center, textColor: .gray200)
    private let countLabel = BibbiLabel(.body2Bold, textAlignment: .center, textColor: .gray300)
    private let imageView = UIImageView()
    private let badgeView = UIImageView()

    let rank: Int = 0
    let count: Int = 0
    let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
        setupAutoLayout()
        setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        addSubviews(imageView, nameLabel, countLabel, badgeView)
    }
    
    private func setupAutoLayout() {
        imageView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalTo(self.snp.width)
        }
        
        badgeView.snp.makeConstraints {
            $0.width.equalTo(imageView.snp.width).dividedBy(3.5)
            $0.height.equalTo(imageView.snp.height).dividedBy(2.8)
            $0.top.equalTo(imageView.snp.bottom).offset(-16)
            $0.centerX.equalTo(imageView)
        }
        
        nameLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(imageView.snp.bottom).offset(7)
            $0.height.equalTo(18)
        }
        
        countLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
            $0.height.equalTo(18)
        }
    }
    
    private func setupAttributes() {
        imageView.do {
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 64 / 2
            $0.layer.borderWidth = 4
        }
    }
}
