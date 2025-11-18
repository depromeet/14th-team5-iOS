//
//  TextLinkAlertView.swift
//  Core
//
//  Created by 김도현 on 9/29/25.
//

import UIKit

import DesignSystem


public class TextLinkAlertView: UIStackView, BBAlertStackView {
    
    //MARK: - Views
    
    private let titleLabel = BBLabel(textAlignment: .center)
    private let subtitleLabel = BBLabel(textAlignment: .center)
    private let linkButton: BBButton = BBButton()
    
    // MARK: - Properties

    public var alert: BBAlert?

    public var linkAction: ((BBAlert?) -> Void)?

    // MARK: - Intializer
    public init(
        _ title: String?,
        titleFontStyle: BBFontStyle? = nil,
        subtitle: String? = nil,
        subtitleFontStyle: BBFontStyle? = nil,
        linkTitle: String? = nil,
        linkTitleFontStyle: BBFontStyle? = nil,
        linkAction: ((BBAlert?) -> Void)? = nil,
        viewConfig: BBAlertViewConfiguration

    ) {
        super.init(frame: .zero)
        setupAttributes()
        self.linkAction = linkAction

        titleLabel.text = title
        titleLabel.fontStyle = titleFontStyle ?? .head2Bold
        titleLabel.numberOfLines = viewConfig.titleNumberOfLines

        linkButton.addTarget(self, action: #selector(handleLinkButtonTapped), for: .touchUpInside)
        linkButton.setAttributedTitle(NSAttributedString(string: linkTitle ?? "", attributes: [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .underlineColor: UIColor.gray300,
            .foregroundColor: UIColor.gray300,
            .font: DesignSystemFontFamily.Pretendard.regular.font(size: 12)
        ]), for: .normal)
        
        addArrangedSubviews(titleLabel, subtitleLabel, linkButton)


        subtitleLabel.text = subtitle
        subtitleLabel.textColor = .gray300
        subtitleLabel.fontStyle = subtitleFontStyle ?? .caption
        subtitleLabel.numberOfLines = 0
        setupAutoLayout()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    @objc
    private func handleLinkButtonTapped() {
        linkAction?(alert)
    }

    private func setupAutoLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.height.equalTo(25)
            $0.horizontalEdges.equalToSuperview()
        }

        subtitleLabel.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.horizontalEdges.equalToSuperview()
        }
    }

    private func setupAttributes() {
        axis = .vertical
        spacing = 8
        alignment = .fill
        distribution = .fillProportionally
    }
}
