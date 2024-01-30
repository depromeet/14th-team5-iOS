//
//  BibbiTermsView.swift
//  Core
//
//  Created by Kim dohyun on 1/2/24.
//

import UIKit

import DesignSystem
import SnapKit
import Then

enum ReasonTypes: String, CaseIterable {
    case reasonOne = "가족과 일상을 공유하고 싶지 않아서"
    case reaosonTwo = "가족 구성원이 참여하지 않아서"
    case reasonThree = "알림 및 위젯 기능을 선호하지 않아서"
    case reasonFour = "서비스 이용이 어렵거나 불편해서"
    case reasonFive = "자주 사용하지 않아서"
}


public final class BibbiCheckBoxView: UIView {
    private let checkStackView: UIStackView = UIStackView()
    public var checkButtons: [UIButton] = []
    
    
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        makeReasonButtons()
        setupUI()
        setupAttributes()
        setupAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupUI() {
        addSubview(checkStackView)
        checkButtons.forEach {
            checkStackView.addArrangedSubviews($0)
        }
    }
    
    func setupAttributes() {
        checkStackView.do {
            $0.axis = .vertical
            $0.distribution = .equalSpacing
            $0.alignment = .leading
            $0.isUserInteractionEnabled = true
        }
    }
    
    func setupAutoLayout() {
        checkStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func makeReasonButtons() {
        ReasonTypes.allCases.enumerated()
            .forEach { index, reason in
                let button = UIButton()
                button.tag = index
                button.changesSelectionAsPrimaryAction = true
                button.configuration = .plain()
                button.configuration?.baseBackgroundColor = .clear
                button.configuration?.imagePadding = 10
                button.configuration?.imagePlacement = .leading
                button.configuration?.attributedTitle = AttributedString(NSAttributedString(string: reason.rawValue, attributes: [
                    .foregroundColor: DesignSystemAsset.gray200.color,
                    .font: DesignSystemFontFamily.Pretendard.regular.font(size: 16),
                    .kern: -0.3
                ]))
                button.configurationUpdateHandler = { button in
                    button.configuration?.image = button.isSelected ? DesignSystemAsset.checkBox.image : DesignSystemAsset.uncheckBox.image
                }
                
                checkButtons.append(button)
            }
    }
    
}
