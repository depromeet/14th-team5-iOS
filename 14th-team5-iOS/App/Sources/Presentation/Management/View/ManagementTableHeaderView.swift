//
//  ManagementTableHeaderView.swift
//  App
//
//  Created by 김건우 on 9/1/24.
//

import DesignSystem
import Core
import UIKit

import SnapKit
import Then

public final class ManagementTableHeaderView: BaseView<ManagementTableHeaderReactor> {
    
    // MARK: - Views
    
    private let titleStack: UIStackView = UIStackView()
    private let familyNameLabel: BBLabel = BBLabel(.head1, textColor: .gray200)
    private let memberCountLabel: BBLabel = BBLabel(.body1Regular, textColor: .gray400)
    private let familyNameEditButton: BBButton = BBButton()
    
    
    // MARK: - Properties
    
    public weak var delegate: ManagementTableHeaderDelegate?
    
    
    // MARK: - Helpers
    
    public override func setupUI() {
        super.setupUI()
        
        self.addSubviews(titleStack, familyNameEditButton)
        titleStack.addArrangedSubviews(familyNameLabel, memberCountLabel)
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        
        titleStack.do {
            $0.axis = .horizontal
            $0.spacing = 10
            $0.alignment = .fill
            $0.distribution = .fillProportionally
        }
        
        familyNameLabel.do {
            $0.text = "나의 가족"
        }
        
        memberCountLabel.do {
            $0.text = "0"
        }
        
        familyNameEditButton.do {
            $0.setImage(DesignSystemAsset.edit.image, for: .normal)
            $0.addTarget(self, action: #selector(didTapFamilyNameEditButton(_:event:)), for: .touchUpInside)
        }
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        
        titleStack.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(24)
        }
        
        familyNameEditButton.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.centerY.equalTo(titleStack)
            $0.trailing.equalToSuperview().offset(-28)
        }
    }
    
}


// MARK: - Extensions

extension ManagementTableHeaderView {
    
    func setTableHeaderInfo(_ familyName: String, count: Int) {
        familyNameLabel.text = familyName
        memberCountLabel.text = String(count)
    }
    
}


extension ManagementTableHeaderView {
    
    @objc func didTapFamilyNameEditButton(_ button: UIButton, event: UIButton.Event) {
        delegate?.tableHeader?(button, didTapFamilyNameEidtButton: event)
    }
    
}
