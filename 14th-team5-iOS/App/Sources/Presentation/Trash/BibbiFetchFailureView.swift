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

@available(*, deprecated)
final public class BibbiFetchFailureView: UIView {
    // MARK: - Type
    public enum FailureType: String {
        case family = "가족"
        case comment = "댓글"
        case post = "피드"
    }
    
    // MARK: - Views
    private let emptyImageView: UIImageView = UIImageView()
    private let labelStack: UIStackView = UIStackView()
    private let mainLabel: BBLabel = BBLabel(.body1Regular, textAlignment: .center, textColor: .gray300)
    private let subLabel: BBLabel = BBLabel(.body2Regular, textAlignment: .center, textColor: .gray500)
    
    // MARK: - Properties
    private var type: FailureType?
    
    // MARK: - Intializer
    public convenience init(type: FailureType? = nil) {
        self.init(frame: .zero)
        
        self.type = type
        setupUI()
        setupAutoLayout()
        setupAttributes()
    }
    
    public override init(frame: CGRect) {
        self.type = nil
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func setupUI() {
        labelStack.addArrangedSubviews(mainLabel, subLabel)
        addSubviews(emptyImageView, labelStack)
    }
    
    private func setupAutoLayout() {
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
    
    private func setupAttributes() {
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
        
        setupMainLabel(type: type)
    }
    
    private func setupMainLabel(type: FailureType?) {
        var labelText = String.none
        if let type = type {
            switch type {
            case .family:
                fallthrough
            case .comment:
                labelText = "\(type.rawValue)을 불러오는데 실패했어요"
            case .post:
                labelText = "\(type.rawValue)를 불러오는데 실패했어요"
            }
        }
        mainLabel.text = labelText        
    }
}
