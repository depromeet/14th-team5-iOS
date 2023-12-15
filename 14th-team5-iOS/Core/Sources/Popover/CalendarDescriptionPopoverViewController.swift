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
    private let descrpitionLabel: UILabel = UILabel()
    
    // MARK: - Intializer
    public init(text: String) {
        super.init(nibName: nil, bundle: nil)
        descrpitionLabel.text = text
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
            $0.top.equalTo(view.snp.top).offset(4.0)
            $0.trailing.equalTo(view.snp.trailing).offset(-4.0)
            $0.bottom.equalTo(view.snp.bottom).offset(-16.0)
        }
    }
    
    private func setupAttributes() {
        descrpitionLabel.do {
            $0.textColor = UIColor.white
            $0.textAlignment = .center
        }
        view.backgroundColor = UIColor.darkGray
    }

}
