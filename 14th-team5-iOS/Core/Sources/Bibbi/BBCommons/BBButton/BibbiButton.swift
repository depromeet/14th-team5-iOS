//
//  BibbiButton.swift
//  Core
//
//  Created by 김건우 on 4/18/24.
//

import UIKit

import SnapKit

final public class BibbiButton: UIButton {
    
    // MARK: - Views
    public var bibbiTitleLabel: BBLabel = BBLabel()
    
    // MARK: - Properties
    public override var titleLabel: UILabel? {
        get {
            return bibbiTitleLabel
        }
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
    
    
    // MARK: - Intializer
    private func setupUI() {
        addSubview(bibbiTitleLabel)
        
        bibbiTitleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    public override func setTitle(_ title: String?, for state: UIControl.State) {
        titleLabel?.text = title
    }
    
    public override func setTitleColor(_ color: UIColor?, for state: UIControl.State) {
        titleLabel?.textColor = color
    }
    
    public func setTitleFontStyle(_ fontStyle: BBFontStyle) {
        if let titleLabel = titleLabel as? BBLabel {
            titleLabel.fontStyle = fontStyle
        }
    }
    
}
