//
//  AccountResignViewCotroller.swift
//  App
//
//  Created by Kim dohyun on 1/1/24.
//

import UIKit

import Core
import DesignSystem
import SnapKit
import Then


final class AccountResignViewCotroller: BaseViewController<AccountResignViewReactor> {
    
    //TODO: 텍스트 컬러, 폰트 정해지면 수정
    private let resignNavigationBarView: BibbiNavigationBarView = BibbiNavigationBarView()
    private let resignDesrptionLabel: BibbiLabel = BibbiLabel(.caption, textColor: .gray200)
    private let resignReasonLabel: BibbiLabel = BibbiLabel(.body1Bold, textColor: .white)
    private let resignExampleLabel: BibbiLabel = BibbiLabel(.caption, textColor: .gray200)
    private let resignIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
    private let confirmButton: UIButton = UIButton()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        super.setupUI()
        view.addSubviews(resignNavigationBarView, resignDesrptionLabel, resignReasonLabel, resignExampleLabel, confirmButton, resignIndicatorView)
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        resignNavigationBarView.do {
            $0.leftBarButtonItem = .arrowLeft
            $0.leftBarButtonItemTintColor = .gray300
            $0.navigationTitle = "회원 탈퇴"
        }
        
        resignDesrptionLabel.do {
            $0.textAlignment = .left
            $0.numberOfLines = 1
            $0.text = "삐삐 서비스와 헤어지게 되어 아쉬워요.."
        }
        
        resignReasonLabel.do {
            $0.textAlignment = .left
            $0.numberOfLines = 0
            $0.text = "탈퇴 사유를 알려주세요.\n삐삐 서비스를 개선하는데 많은 도움이 됩니다.\n더 나은 서비스가 될 수 있도록 노력할게요!"
        }
        
        resignExampleLabel.do {
            $0.textAlignment = .left
            $0.numberOfLines = 1
            $0.text = "최소 1개 이상 선택해 주세요."
        }
        
        resignIndicatorView.do {
            $0.hidesWhenStopped = true
            $0.color = .gray
        }
        
        confirmButton.do {
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
            $0.setTitle("탈퇴 하기", for: .normal)
            $0.titleLabel?.font = DesignSystemFontFamily.Pretendard.semiBold.font(size: 16)
            $0.setTitleColor(DesignSystemAsset.black.color, for: .normal)
            $0.backgroundColor = DesignSystemAsset.gray100.color
            $0.isEnabled = false
        }
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        resignNavigationBarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(42)
        }
        
        resignDesrptionLabel.snp.makeConstraints {
            $0.top.equalTo(resignNavigationBarView.snp.bottom).offset(26)
            $0.left.equalToSuperview().offset(16)
            $0.centerX.equalTo(resignNavigationBarView)
            $0.height.equalTo(18)
        }
        
        resignReasonLabel.snp.makeConstraints {
            $0.top.equalTo(resignDesrptionLabel.snp.bottom).offset(24)
            $0.left.equalToSuperview().offset(12)
            $0.height.equalTo(72)
            $0.centerX.equalTo(resignNavigationBarView)
        }
        
        resignExampleLabel.snp.makeConstraints {
            $0.top.equalTo(resignReasonLabel.snp.bottom).offset(24)
            $0.left.equalToSuperview().offset(12)
            $0.height.equalTo(18)
            $0.centerX.equalTo(resignNavigationBarView)
        }
        
        confirmButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(56)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin)
        }
        
    }
    
}
