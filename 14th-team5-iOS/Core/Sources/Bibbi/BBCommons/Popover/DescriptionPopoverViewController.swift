//
//  CalendarDescriptionPopoverViewController.swift
//  App
//
//  Created by 김건우 on 12/7/23.
//

import UIKit

import SnapKit
import Then

public final class PopoverDescriptionViewController: UIViewController {
    // MARK: - Views
    private let descrpitionLabel: BBLabel = BBLabel(.body2Regular)
    
    // MARK: - Properties
    public var labelText: String
    public var arrowDirection: UIPopoverArrowDirection
    
    // MARK: - Intializer
    public init(_ text: String, arrowDirection: UIPopoverArrowDirection) {
        self.labelText = text
        self.arrowDirection = arrowDirection
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycles
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAutoLayout()
        setupAttributes()
    }
    
    private func setupUI() {
        view.addSubview(descrpitionLabel)
    }
    
    private func setupAutoLayout() {
        descrpitionLabel.snp.makeConstraints {
            $0.leading.equalTo(view.snp.leading).offset(4.0)
            $0.top.equalTo(view.snp.top).offset(arrowDirection == .up ? 24.0 : 8.0)
            $0.trailing.equalTo(view.snp.trailing).offset(-4.0)
            $0.bottom.equalTo(view.snp.bottom).offset(arrowDirection == .up ? -8.0 : -24.0)
        }
    }
    
    private func setupAttributes() {
        descrpitionLabel.do {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 3
            
            let attrString = NSMutableAttributedString(string: labelText)
            attrString.addAttribute(
                .paragraphStyle,
                value:paragraphStyle,
                range:NSMakeRange(0, attrString.length)
            )
            
            $0.attributedText = attrString
            $0.textColor = UIColor.white
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        view.backgroundColor = UIColor.darkGray
    }

}
