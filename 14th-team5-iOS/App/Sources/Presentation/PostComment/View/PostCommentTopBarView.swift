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

final class PostCommentTopBarView: UIView {
    // MARK: - Views
    private let grabber: UIView = UIView()
    
    private let titleLabel: BibbiLabel = BibbiLabel(.body1Bold)
    private let barDividerView: UIView = UIView()
    
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
        self.addSubviews(grabber, titleLabel, barDividerView)
    }
    
    func setupAutoLayout() {
        grabber.snp.makeConstraints {
            $0.width.equalTo(36)
            $0.height.equalTo(5.08)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(6)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-12)
        }
        
        barDividerView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
    func setupAttributes() {
        grabber.do {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 5.08 / 2.0
            $0.backgroundColor = UIColor.gray500
        }
        
        titleLabel.do {
            $0.text = "댓글"
        }
        
        barDividerView.do {
            $0.backgroundColor = UIColor.gray700
        }
    }
}
