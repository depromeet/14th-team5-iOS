//
//  noCommentLabel.swift
//  App
//
//  Created by 김건우 on 1/18/24.
//

import Core
import UIKit

import Then
import SnapKit

// NoneCommentView

final class NoneCommentView: UIView {
    
    // MARK: - Views
    
    private let labelStack: UIStackView = UIStackView()
    private let mainTextLabel: BBLabel = BBLabel(.body1Bold, textAlignment: .center)
    private let subTextLabel: BBLabel = BBLabel(.body2Regular, textAlignment: .center, textColor: .gray500)
    
    
    // MARK: - Intializer
    
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
        addSubview(labelStack)
        labelStack.addArrangedSubviews(mainTextLabel, subTextLabel)
    }
    
    func setupAutoLayout() {
        labelStack.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func setupAttributes() {
        labelStack.do {
            $0.axis = .vertical
            $0.spacing = 12
            $0.alignment = .fill
            $0.distribution = .fillProportionally
        }
        
        mainTextLabel.do {
            $0.text = "아직 댓글이 없습니다"
        }
        
        subTextLabel.do {
            $0.text = "댓글을 남겨보세요"
        }
    }
}
