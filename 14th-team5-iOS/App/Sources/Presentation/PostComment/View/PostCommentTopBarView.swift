//
//  PostCommentTopBarView.swift
//  App
//
//  Created by 김건우 on 1/18/24.
//

import Core
import UIKit

import Then

final class PostCommentTopBarView: UIView {
    // MARK: - Views
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
        self.addSubviews(titleLabel, barDividerView)
    }
    
    func setupAutoLayout() {
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        barDividerView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
    func setupAttributes() {
        titleLabel.do {
            $0.text = "댓글"
        }
        
        barDividerView.do {
            $0.backgroundColor = .gray700
        }
    }
}
