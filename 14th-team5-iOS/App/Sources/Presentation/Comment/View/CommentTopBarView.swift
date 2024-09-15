//
//  PostCommentTopBarView.swift
//  App
//
//  Created by 김건우 on 1/18/24.
//

import Core
import UIKit

import Then
import SnapKit

final class CommentTopBarView: UIView {
    
    // MARK: - Views
    
    private let grabber: UIView = UIView()
    private let titleLabel: BBLabel = BBLabel(.body1Bold)
    private let divider: UIView = UIView()
    
    
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
        addSubviews(grabber, titleLabel, divider)
    }
    
    func setupAutoLayout() {
        grabber.snp.makeConstraints {
            $0.width.equalTo(36)
            $0.height.equalTo(5)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(6)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-12)
        }
        
        divider.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    func setupAttributes() {
        grabber.do {
            $0.layer.cornerRadius = 2.5
            $0.backgroundColor = UIColor.gray500
        }
        
        titleLabel.do {
            $0.text = "댓글"
        }
        
        divider.do {
            $0.backgroundColor = UIColor.gray700
        }
    }
}
