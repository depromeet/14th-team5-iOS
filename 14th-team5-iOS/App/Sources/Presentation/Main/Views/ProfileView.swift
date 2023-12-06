//
//  ProfileView.swift
//  App
//
//  Created by 마경미 on 05.12.23.
//

import UIKit

import Kingfisher
import RxSwift

struct ProfileData {
    let imageURL: String
    let name: String
}

final class ProfileView: UIView {
    let disposeBag = DisposeBag()
    
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
        setupAutoLayout()
        setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

//    private func bind(reactor: R) { }

    private func setupUI() {
        imageView.do {
            $0.kf.setImage(with: URL(string:MainStringLiterals.tempProfileImageURL))
        }
        
        nameLabel.do {
            $0.text = MainStringLiterals.tempProfileName
//            $0.font =
        }
    }

    private func setupAutoLayout() {
        addSubview(imageView)
        addSubview(nameLabel)
        
        imageView.snp.makeConstraints { make in
            make.size.equalTo(68)
            make.top.leading.equalToSuperview()
        }
    }

    private func setupAttributes() { }
}
