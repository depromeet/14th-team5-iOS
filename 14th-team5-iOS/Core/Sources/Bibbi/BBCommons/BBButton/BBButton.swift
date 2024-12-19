//
//  BibbiButton.swift
//  Core
//
//  Created by 김건우 on 4/18/24.
//

import UIKit

import SnapKit


/// BBButton은 `titleLabel`이 BBFontStyle에 맞게 커스텀되어 있는 버튼입니다.
public class BBButton: UIButton {
    
    // MARK: - Views
    private var mainStackView: UIStackView = UIStackView()
    public var mainImageView: UIImageView = UIImageView()
    public var mainTitleLabel: BBLabel = BBLabel()
    
    // MARK: - Properties
    
    public var id: Int?
    private var backgroundColors: [UIControl.State: UIColor] = [:]
    
    public override var titleLabel: UILabel? {
        get { mainTitleLabel }
        set { }
    }
    
    public override var isEnabled: Bool {
         didSet {
             updateBackgroundColor()
         }
     }
    
    public override var isHighlighted: Bool {
        didSet {
            guard
                oldValue != self.isHighlighted
            else { return }
            
            UIView.animate(withDuration: 0.1, delay: 0, options: [.beginFromCurrentState]) {
                self.alpha = self.isHighlighted ? 0.5 : 1
            }
        }
    }
    
    
    // MARK: - Intializer
    
    public override init(frame: CGRect) {
        self.id = nil
        super.init(frame: frame)
        
        setupUI()
        setupConstraints()
        setupAttributes()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - Helpers
    
    private func setupUI() {
        addSubviews(mainStackView)
        mainStackView.addArrangedSubviews(mainImageView, mainTitleLabel)
    }
    
    private func setupConstraints() {
        mainStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func setupAttributes() {
        mainStackView.do {
            $0.spacing = 4
            $0.distribution = .fillProportionally
            $0.axis = .horizontal
            $0.isUserInteractionEnabled = false
        }
        
        mainTitleLabel.do {
            $0.numberOfLines = 1
        }
    }
    
    private func updateBackgroundColor() {
          if let color = backgroundColors[state] {
              self.backgroundColor = color
          } else if let normalColor = backgroundColors[.normal] {
              self.backgroundColor = normalColor
          }
      }
      
      public func setButtonBackgroundColor(_ backgroundColor: UIColor, for state: UIControl.State) {
          backgroundColors[state] = backgroundColor
          updateBackgroundColor()
      }
    
    
    /// 버튼이 가진 고유한 ID값을 변경합니다.
    public func setId(_ id: Int) {
        self.id = id
    }
    
    /// 버튼의 이미지를 변경합니다.
    public func setImage(_ image: UIImage?) {
        mainImageView.image = image
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


extension UIControl.State: Hashable { }
