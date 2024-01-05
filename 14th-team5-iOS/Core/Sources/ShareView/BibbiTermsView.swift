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
    case reasonOne = "사유1"
    case reaosonTwo = "사유2"
    case reasonThree = "사유3"
    case reasonFour = "사유4"
    case reasonFive = "사유5"
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
            $0.spacing = 20
            $0.distribution = .fillEqually
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
                    .font: DesignSystemFontFamily.Pretendard.semiBold.font(size: 16),
                    .kern: -0.3
                ]))
                button.configurationUpdateHandler = { button in
                    button.configuration?.image = button.isSelected ? DesignSystemAsset.checkBox.image : DesignSystemAsset.uncheckBox.image
                }
                
                checkButtons.append(button)
            }
    }
    
}
