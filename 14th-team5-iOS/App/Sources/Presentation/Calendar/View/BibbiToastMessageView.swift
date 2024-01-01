//
//  AllFamilyUploadedView.swift
//  App
//
//  Created by 김건우 on 1/3/24.
//

import UIKit

import Core

final public class BibbiToastMessageView: UIView {
    // MARK: - Views
    private let backgroundView: UIView = UIView()
    private let textLabel: BibbiLabel = BibbiLabel(.body1Regular, alignment: .center, textColor: .bibbiWhite)
    
    public var text: String = "" {
        didSet {
            textLabel.text = text
        }
    }
    
    // MARK: - Intializer
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
        setupAutoLayout()
        setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func setupUI() {
        addSubview(backgroundView)
        backgroundView.addSubview(textLabel)
    }
    
    private func setupAutoLayout() {
        backgroundView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.equalTo(300.0)
            $0.height.equalTo(56.0)
        }
        
        textLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func setupAttributes() {
        backgroundView.do {
            $0.backgroundColor = UIColor.bibbiBlack
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 28.0
        }
    }
}
