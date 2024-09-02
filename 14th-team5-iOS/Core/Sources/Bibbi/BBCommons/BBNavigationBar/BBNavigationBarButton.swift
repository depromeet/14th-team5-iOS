//
//  NavigationBarButton.swift
//  Core
//
//  Created by 김건우 on 8/11/24.
//

import DesignSystem
import UIKit

import Then
import SnapKit

public final class BBNavigationBarButton: BBButton {
    
    // MARK: - Views
    
    private let markImageView = UIImageView()
    
    
    // MARK: - Properties
    
    public var type: BBNavigationButtonStyle? = nil {
        didSet {
            setBarButtonImage(for: type)
        }
    }
    
    public var isHiddenMark: Bool = true {
        didSet {
            markImageView.isHidden = isHiddenMark
        }
    }
    
    public var markPosition: MarkPosition = .topTrailing() {
        didSet {
            updateNewMarkPosition(for: markPosition)
        }
    }
    
    
    // MARK: - Intitalizer
    
    public init(with type: BBNavigationButtonStyle? = nil) {
        super.init(frame: .zero)
        setBarButtonImage(for: type)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupConstraints()
        setupAttributes()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func setupUI() {
        addSubview(markImageView)
    }
    
    private func setupConstraints() {
        markImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(7)
            $0.trailing.equalToSuperview().offset(10)
        }
    }
    
    private func setupAttributes() {
        self.do {
            $0.clipsToBounds = false
            $0.layer.cornerRadius = 10
            $0.tintColor = .gray300
        }
        
        markImageView.do {
            $0.image = DesignSystemAsset.new.image
            $0.isHidden = true
            $0.contentMode = .scaleAspectFit
        }
    }
    
    
    private func setBarButtonImage(for type: BBNavigationButtonStyle?) {
        setImage(type?.image, for: .normal)
    }
    
    private func updateNewMarkPosition(for position: MarkPosition) {
        switch position {
        case let .topLeading(xOffset, yOffset):
            markImageView.snp.remakeConstraints {
                $0.top.equalToSuperview().offset(yOffset)
                $0.leading.equalToSuperview().offset(xOffset)
            }
            
        case let .topTrailing(xOffset, yOffset):
            markImageView.snp.remakeConstraints {
                $0.top.equalToSuperview().offset(yOffset)
                $0.trailing.equalToSuperview().offset(xOffset)
            }
        }
    }
    
}


// MARK: - Extensions

extension BBNavigationBarButton {
    
    public enum MarkPosition {
        /// xOffset 기본값: -11, yOffset 기본값: 10
        case topLeading(xOffset: CGFloat = -11, yOffset: CGFloat = 10)
        /// xOffset 기본값: 7, yOffset 기본값: 10
        case topTrailing(xOffset: CGFloat = 7, yOffset: CGFloat = 10)
    }
    
}
