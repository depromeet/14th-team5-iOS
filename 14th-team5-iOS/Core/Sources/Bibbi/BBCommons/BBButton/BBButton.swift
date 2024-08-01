//
//  BibbiButton.swift
//  Core
//
//  Created by 김건우 on 4/18/24.
//

import UIKit

import SnapKit

final public class BBButton: UIButton {
    
    // MARK: - Views
    
    public var bibbiTitleLabel: BBLabel = BBLabel()
    
    // MARK: - Properties
    
    public override var titleLabel: UILabel? {
        get { bibbiTitleLabel }
        set { }
    }
    
    // MARK: - Intializer
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - Helpers
    
    private func setupUI() {
        addSubview(bibbiTitleLabel)
        
        bibbiTitleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    /// 버튼의 타이틀을 변경합니다.
    public override func setTitle(_ title: String?, for state: UIControl.State) {
        titleLabel?.text = title
    }
    
    /// 버튼의 타이틀 색상을 변경합니다.
    public override func setTitleColor(_ color: UIColor?, for state: UIControl.State) {
        titleLabel?.textColor = color
    }
    
    /// 버튼의 타이틀 폰트 스타일을 변경합니다.
    public func setTitleFontStyle(_ fontStyle: BBFontStyle) {
        if let titleLabel = titleLabel as? BBLabel {
            titleLabel.fontStyle = fontStyle
        }
    }
    
}
