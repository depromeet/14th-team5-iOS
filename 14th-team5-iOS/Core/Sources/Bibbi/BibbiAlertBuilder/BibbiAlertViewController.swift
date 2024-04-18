//
//  BibbiAlertViewController.swift
//  Core
//
//  Created by 김건우 on 4/18/24.
//

import DesignSystem
import UIKit

import SnapKit
import Then

public final class BibbiAlertViewController: UIViewController {
    
    // MARK: - Views
    private var containerView: UIView = UIView()
    private var alertStackView: UIStackView = UIStackView()
    private var labelStackView: UIStackView = UIStackView()
    private var subTitleLabel: BibbiLabel = BibbiLabel(.head2Bold)
    private var mainTitleLabel: BibbiLabel = BibbiLabel(.body2Regular)
    private var imageView: UIImageView = UIImageView()
    private var buttonStackView: UIStackView = UIStackView()
    private var confirmButton: UIButton = UIButton(type: .system)
    private var cancelButton: UIButton = UIButton(type: .system)
    
    // MARK: - Properties
    var subTitle: BibbiAlertTitle? {
        didSet {
            subTitleLabel.text = subTitle?.text
            subTitleLabel.textColor = subTitle?.textColor
            subTitleLabel.fontStyle = subTitle?.fontStyle ?? .head2Bold
        }
    }
    var mainTitle: BibbiAlertTitle? {
        didSet {
            mainTitleLabel.text = mainTitle?.text
            mainTitleLabel.textColor = mainTitle?.textColor
            mainTitleLabel.fontStyle = mainTitle?.fontStyle ?? .body2Regular
        }
    }
    var image: DesignSystemImages.Image? {
        didSet {
            imageView.image = image
        }
    }
    
    var confirmAction: BibbiAlertAction? {
        didSet {
            confirmButton.setTitle(
                confirmAction?.text,
                for: .normal
            )
            confirmButton.titleLabel?.font = UIFont.pretendard(
                confirmAction?.fontStlye ?? .body1Bold
            )
            confirmButton.setTitleColor(
                confirmAction?.textColor,
                for: .normal
            )
            confirmButton.setBackgroundColor(
                confirmAction?.backgroundColor ?? .mainYellow,
                for: .normal
            )
            
            confirmButton.addTarget(
                self,
                action: #selector(didTapConfirmAction(_:)),
                for: .touchUpInside
            )
        }
    }
    var cancelAction: BibbiAlertAction? {
        didSet {
            cancelButton.setTitle(
                cancelAction?.text,
                for: .normal
            )
            cancelButton.titleLabel?.font = UIFont.pretendard(
                confirmAction?.fontStlye ?? .body1Bold
            )
            cancelButton.setTitleColor(
                cancelAction?.textColor,
                for: .normal
            )
            cancelButton.setBackgroundColor(
                cancelAction?.backgroundColor ?? .gray700,
                for: .normal
            )
            
            cancelButton.addTarget(
                self,
                action: #selector(didTapCancelAction(_:)),
                for: .touchUpInside
            )
        }
    }
    
    // MARK: - LifeCyclces
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
        setupAttributes()
    }
    
    // MARK: - Intializer
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func setupUI() {
        view.addSubviews(containerView)
        containerView.addSubview(alertStackView)
        labelStackView.addArrangedSubviews(mainTitleLabel, subTitleLabel)
        buttonStackView.addArrangedSubviews(confirmButton, cancelButton)
        alertStackView.addArrangedSubviews(labelStackView, imageView, buttonStackView)
        
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints {
            $0.width.equalTo(280)
            $0.height.equalTo(384)
            $0.center.equalToSuperview()
        }
        
        alertStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(36)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-12)
        }
        
        mainTitleLabel.snp.makeConstraints {
            $0.height.equalTo(25)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        
//        imageView.snp.makeConstraints {
//            $0.height.equalTo(151)
//        }
        
        confirmButton.snp.makeConstraints {
            $0.height.equalTo(45)
        }
        
        cancelButton.snp.makeConstraints {
            $0.height.equalTo(45)
        }
    }
    
    private func setupAttributes() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        containerView.do {
            $0.backgroundColor = UIColor.bibbiBlack
            $0.layer.cornerRadius = 16
        }
        
        alertStackView.do {
            $0.axis = .vertical
            $0.spacing = 0
            $0.alignment = .fill
            $0.distribution = .fillProportionally
        }
        
        labelStackView.do {
            $0.axis = .vertical
            $0.spacing = 8
            $0.alignment = .fill
            $0.distribution = .fillProportionally
        }
        
        mainTitleLabel.do {
            $0.textAlignment = .center
        }
        
        subTitleLabel.do {
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        
        imageView.do {
            $0.contentMode = .scaleAspectFit
        }
        
        buttonStackView.do {
            $0.axis = .vertical
            $0.spacing = 8
            $0.alignment = .fill
            $0.distribution = .fillProportionally
        }
        
        confirmButton.do {
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
        }
        
        cancelButton.do {
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
        }
    }
}

// MARK: - Extensions
extension BibbiAlertViewController {
    
    @objc func didTapConfirmAction(_ sender: UIButton) {
        confirmAction?.action?(self)
    }
    
    @objc func didTapCancelAction(_ sender: UIButton) {
        if let action = cancelAction?.action {
            action(self)
        } else {
            self.dismiss(animated: true)
        }
    }
    
}