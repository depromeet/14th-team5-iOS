//
//  PrivacyHeaderFooterView.swift
//  App
//
//  Created by Kim dohyun on 12/16/23.
//

import UIKit

import Core
import DesignSystem
import SnapKit
import Then


public final class PrivacyHeaderFooterView: UITableViewHeaderFooterView {
    private let headerLabel: BBLabel = BBLabel(.body2Regular, textColor: .gray300)
    
    
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
        setupAttributes()
        setupAutoLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(headerLabel)
    }
    
    private func setupAttributes() {
        headerLabel.do {
            $0.text = "계정 및 권한"
            $0.textAlignment = .left
        }
    }
    
    private func setupAutoLayout() {
        headerLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(12)
            $0.top.equalToSuperview()
            $0.height.equalTo(18)
            $0.centerY.equalToSuperview()
        }
    }
}
