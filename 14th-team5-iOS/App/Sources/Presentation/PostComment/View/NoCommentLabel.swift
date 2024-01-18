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

final class NoCommentLabel: UIView {
    // MARK: - Views
    private let labelStack: UIStackView = UIStackView()
    private let mainLabel: BibbiLabel = BibbiLabel(.body1Bold, alignment: .center)
    private let subLabel: BibbiLabel = BibbiLabel(.body2Regular, alignment: .center, textColor: .gray500)
    
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
        labelStack.addArrangedSubviews(mainLabel, subLabel)
        self.addSubview(labelStack)
    }
    
    func setupAutoLayout() {
        labelStack.snp.makeConstraints {
            $0.top.equalTo(self.snp.top).offset(65)
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
        
        mainLabel.do {
            $0.text = "아직 댓글이 없습니다"
        }
        
        subLabel.do {
            $0.text = "댓글을 남겨보세요"
        }
    }
}
