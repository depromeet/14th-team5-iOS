//
//  FetchFailureView.swift
//  App
//
//  Created by 김건우 on 1/30/24.
//

import Core
import DesignSystem
import UIKit

import Then
import SnapKit

final class FetchFailureView: UIView {
    // MARK: - Type
    enum FailureType: String {
        case family = "가족"
        case comment = "댓글"
        case post = "피드"
    }
    
    // MARK: - Views
    private let emptyImageView: UIImageView = UIImageView()
    private let labelStack: UIStackView = UIStackView()
    private let mainLabel: BibbiLabel = BibbiLabel(.body1Regular, alignment: .center, textColor: .gray300)
    private let subLabel: BibbiLabel = BibbiLabel(.body2Regular, alignment: .center, textColor: .gray500)
    
    // MARK: - Intializer
    convenience init(type: FailureType = .family) {
        self.init(frame: .zero)
        setupMainLabel(type: type)
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
        setupAutoLayout()
        setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    func setupUI() {
        labelStack.addArrangedSubviews(mainLabel, subLabel)
        addSubviews(emptyImageView, labelStack)
    }
    
    func setupAutoLayout() {
        emptyImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(335)
            $0.height.equalTo(150)
        }
        
        labelStack.snp.makeConstraints {
            $0.top.equalTo(emptyImageView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
    }
    
    func setupAttributes() {
        labelStack.do {
            $0.axis = .vertical
            $0.spacing = 12
            $0.alignment = .fill
            $0.distribution = .fillProportionally
        }
        
        emptyImageView.do {
            $0.image = DesignSystemAsset.profileEmpty.image
            $0.contentMode = .scaleAspectFit
        }
        
        subLabel.do {
            $0.text = "잠시 후 다시 시도해주세요"
        }
    }
    
    func setupMainLabel(type: FailureType) {
        switch type {
        case .family:
            fallthrough
        case .comment:
            mainLabel.text = "\(type.rawValue)을 불러오는데 실패했어요"
        case .post:
            mainLabel.text = "\(type.rawValue)를 불러오는데 실패했어요"
        }
    }
}
