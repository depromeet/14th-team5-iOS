//
//  InvitationUrlContainerView.swift
//  App
//
//  Created by 김건우 on 1/16/24.
//

import Core
import DesignSystem
import UIKit


// MARK: - Typealias

fileprivate typealias _Str = ManagementStrings // SharingRoundedRectStrings 로 수정


// MARK: - ViewController

public final class SharingContainerView: BaseView<SharingContainerReactor> {
    
    // MARK: - Views
    
    private let containerView: UIView = UIView()
    private let envelopeImageView: UIImageView = UIImageView()
    
    private let labelStack: UIStackView = UIStackView()
    private let sharingDescriptionLabel: BBLabel = BBLabel(.head2Bold, textColor: .gray200)
    private let sharingUrlLabel: BBLabel = BBLabel(.body2Regular, textColor: .gray300)
    private let sharingImageView: UIImageView = UIImageView()
    
    private let basicProgressHud: UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    // MARK: - Properties
    
    public weak var delegate: SharingContainerDlegate?
    
    
    // MARK: - Intialzier
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helpers
    
    public override func bind(reactor: SharingContainerReactor) {
        super.bind(reactor: reactor)
        
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: SharingContainerReactor) { }
    
    private func bindOutput(reactor: SharingContainerReactor) {
        let hiddenProgressHud = reactor.state
            .map { $0.hiddenProgresHud }
            .asDriver(onErrorJustReturn: true)
        
        hiddenProgressHud
            .distinctUntilChanged()
            .drive(basicProgressHud.rx.isHidden)
            .disposed(by: disposeBag)
        
        hiddenProgressHud
            .map { !$0 }
            .distinctUntilChanged()
            .drive(basicProgressHud.rx.isAnimating)
            .disposed(by: disposeBag)
        
        hiddenProgressHud
            .map { !$0 }
            .distinctUntilChanged()
            .drive(sharingImageView.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    public override func setupUI() {
        super.setupUI()
        
        self.addSubviews(containerView)
        containerView.addSubviews(envelopeImageView, labelStack, sharingImageView, basicProgressHud)
        labelStack.addArrangedSubviews(sharingDescriptionLabel, sharingUrlLabel)
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        envelopeImageView.snp.makeConstraints {
            $0.size.equalTo(50)
            $0.leading.equalTo(containerView.snp.leading).offset(16)
            $0.centerY.equalTo(containerView.snp.centerY)
        }
        
        labelStack.snp.makeConstraints {
            $0.leading.equalTo(envelopeImageView.snp.trailing).offset(16)
            $0.centerY.equalTo(containerView.snp.centerY)
        }
        
        sharingImageView.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.trailing.equalTo(containerView.snp.trailing).offset(-24)
            $0.centerY.equalTo(containerView.snp.centerY)
        }
        
        basicProgressHud.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.trailing.equalTo(containerView.snp.trailing).offset(-24)
            $0.centerY.equalTo(containerView.snp.centerY)
        }
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        
        containerView.do {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 16
            $0.backgroundColor = UIColor.gray800
        }
        
        envelopeImageView.do {
            $0.image = DesignSystemAsset.envelope.image
            $0.contentMode = .scaleAspectFit
        }
        
        labelStack.do {
            $0.axis = .vertical
            $0.spacing = 3
            $0.alignment = .leading
            $0.distribution = .fillProportionally
        }
        
        sharingDescriptionLabel.do {
            $0.text = _Str.inviteDescText
        }
        
        sharingUrlLabel.do {
            $0.text = _Str.invitationUrlText
        }

        sharingImageView.do {
            $0.image = DesignSystemAsset.shareLine.image
            $0.tintColor = .gray500
            $0.contentMode = .scaleAspectFit
        }
        
        basicProgressHud.do {
            $0.color = UIColor.bibbiWhite
            $0.isHidden = true
            $0.style = .medium
        }
    }
}
