//
//  BibbiButton.swift
//  Core
//
//  Created by 김건우 on 4/18/24.
//

import UIKit

import SnapKit

public class BBButton: UIButton {

    // MARK: - Views
    private let mainStackView = UIStackView()
    public let mainImageView = UIImageView() // 프로토타입(값 보관용)
    public let mainTitleLabel = BBLabel()    // 프로토타입(값 보관용)

    // MARK: - Properties
    public var id: Int?
    private var backgroundColors: [UIControl.State: UIColor] = [:]
    private var imageTintColor: UIColor?

    public override var titleLabel: UILabel? {
        get { mainTitleLabel } // 프로토타입 라벨을 titleLabel로 노출
        set { }
    }

    public override var isEnabled: Bool {
        didSet { updateBackgroundColor() }
    }

    public override var isHighlighted: Bool {
        didSet {
            guard oldValue != isHighlighted else { return }
            UIView.animate(withDuration: 0.1, delay: 0, options: [.beginFromCurrentState]) {
                self.alpha = self.isHighlighted ? 0.5 : 1
            }
        }
    }

    // MARK: - Layout Tokens
    public enum LayoutToken: Equatable {
        case text
        case image
        case spacer(CGFloat)
    }

    private var layoutTokens: [LayoutToken] = [.image, .text]

    public func setLayout(
        _ tokens: [LayoutToken],
        spacing: CGFloat? = nil,
        alignment: UIStackView.Alignment? = nil,
        distribution: UIStackView.Distribution? = nil
    ) {
        layoutTokens = tokens
        rebuildStackView(tokens)
        if let spacing { mainStackView.spacing = spacing }
        if let alignment { mainStackView.alignment = alignment }
        if let distribution { mainStackView.distribution = distribution }
    }

    // MARK: - Initializer
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        setupAttributes()
        rebuildStackView(layoutTokens) // ✅ 초기 빌드
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        setupConstraints()
        setupAttributes()
        rebuildStackView(layoutTokens)
    }

    // MARK: - Public API
    public func setId(_ id: Int) { self.id = id }

    /// 프로토타입 이미지 설정
    public func setImage(_ image: UIImage?) {
        mainImageView.image = image
        rebuildStackView(layoutTokens)
    }
    
    public func setImageTintColor(_ color: UIColor?) {
        imageTintColor = color
        mainImageView.tintColor = color
        rebuildStackView(layoutTokens)
    }

    /// 프로토타입 타이틀 설정
    public override func setTitle(_ title: String?, for state: UIControl.State) {
        (titleLabel as? BBLabel)?.text = title
        rebuildStackView(layoutTokens)
    }

    public override func setTitleColor(_ color: UIColor?, for state: UIControl.State) {
        (titleLabel as? BBLabel)?.textColor = color
        copyTitleAppearanceToAllTextLabels()
    }

    public func setTitleFontStyle(_ fontStyle: BBFontStyle) {
        (titleLabel as? BBLabel)?.fontStyle = fontStyle
        copyTitleAppearanceToAllTextLabels()
    }

    public func setButtonBackgroundColor(_ backgroundColor: UIColor, for state: UIControl.State) {
        backgroundColors[state] = backgroundColor
        updateBackgroundColor()
    }

    // MARK: - Private
    private func setupUI() {
        addSubview(mainStackView)
        // ❌ 초기 arrangedSubviews 추가하지 않음 (rebuildStackView가 생성함)
    }

    private func setupConstraints() {
        mainStackView.snp.makeConstraints { $0.center.equalToSuperview() }
    }

    private func setupAttributes() {
        mainStackView.axis = .horizontal
        mainStackView.spacing = 4
        mainStackView.distribution = .fillProportionally
        mainStackView.isUserInteractionEnabled = false

        mainTitleLabel.numberOfLines = 1
    }

    private func updateBackgroundColor() {
        if let color = backgroundColors[state] {
            backgroundColor = color
        } else if let normal = backgroundColors[ .normal ] {
            backgroundColor = normal
        }
    }

    private func rebuildStackView(_ tokens: [LayoutToken]) {
        // 기존 제거
        mainStackView.arrangedSubviews.forEach {
            mainStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        // 프로토타입 값들
        let proto = (titleLabel as? BBLabel)
        let currentText = proto?.text
        let currentTextColor = proto?.textColor
        let currentFontStyle = proto?.fontStyle
        let currentImage = mainImageView.image

        // 토큰대로 생성
        for token in tokens {
            switch token {
            case .text:
                let label = BBLabel()
                label.numberOfLines = 1
                label.isUserInteractionEnabled = false
                label.text = currentText
                if let style = currentFontStyle { label.fontStyle = style }
                if let color = currentTextColor { label.textColor = color }
                mainStackView.addArrangedSubview(label)

            case .image:
                let iv = UIImageView(image: currentImage)
                iv.isUserInteractionEnabled = false
                iv.setContentHuggingPriority(.required, for: .horizontal)
                iv.setContentCompressionResistancePriority(.required, for: .horizontal)
                
                if let tintColor = imageTintColor {
                    iv.image = currentImage?.withRenderingMode(.alwaysTemplate)
                    iv.tintColor = tintColor
                }
                
                mainStackView.addArrangedSubview(iv)

            case .spacer(let width):
                let spacer = UIView()
                spacer.isUserInteractionEnabled = false
                spacer.snp.makeConstraints { $0.width.equalTo(width) }
                mainStackView.addArrangedSubview(spacer)
            }
        }
    }

    private func copyTitleAppearanceToAllTextLabels() {
        guard let proto = titleLabel as? BBLabel else { return }
        mainStackView.arrangedSubviews
            .compactMap { $0 as? BBLabel }
            .forEach {
                $0.textColor = proto.textColor
                $0.fontStyle = proto.fontStyle
            }
    }
}

extension UIControl.State: Hashable {}
