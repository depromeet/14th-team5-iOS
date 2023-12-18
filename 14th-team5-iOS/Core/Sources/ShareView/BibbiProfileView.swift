//
//  BibbiProfileView.swift
//  Core
//
//  Created by Kim dohyun on 12/17/23.
//

import UIKit

import DesignSystem
import RxSwift
import RxCocoa
import ReactorKit
import SnapKit
import Then




public class BibbiProfileView: BaseView<BibbiProfileViewReactor> {
    public let profileImageView: UIImageView = UIImageView()
    public let circleButton: UIButton = UIButton.createCircleButton(radius: 15)
    public let profileNickNameButton: UIButton = UIButton(configuration: .filled(), primaryAction: nil)
    
    private var cornerRadius: CGFloat
    public init(cornerRadius: CGFloat, reactor: BibbiProfileViewReactor) {
        self.cornerRadius = cornerRadius
        super.init(frame: .zero)
        self.reactor = reactor
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public override func setupUI() {
        super.setupUI()
        [profileImageView, profileNickNameButton, circleButton].forEach(self.addSubview(_:))
    }
    
    public override func setupAttributes() {
        
        guard let originImageURL = URL(string: "https://src.hidoc.co.kr/image/lib/2021/4/28/1619598179113_0.jpg"),
              let originData = try? Data(contentsOf: originImageURL) else { return }
        
        super.setupAttributes()
        profileImageView.do {
            $0.clipsToBounds = true
            $0.image = UIImage(data: originData)
            $0.contentMode = .scaleToFill
            $0.layer.cornerRadius = cornerRadius
        }
        
        circleButton.do {
            $0.backgroundColor = .white
            $0.setImage(DesignSystemAsset.camera.image, for: .normal)
        }
        
        profileNickNameButton.do {
            var attributedsString: AttributedString = AttributedString("하나밖에없는 혈육")
            attributedsString.font = .system(size: 16, weight: .regular)
            attributedsString.foregroundColor = .gray
            $0.configuration?.imagePlacement = .trailing
            $0.configuration?.baseBackgroundColor = .clear
            $0.configuration?.attributedTitle = attributedsString
            $0.configuration?.title = "하나빡에없는 혈육"
            $0.configuration?.image = DesignSystemAsset.edit.image
            $0.configuration?.imagePadding = 5
        }
        
        

    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        
        profileImageView.snp.makeConstraints {
            $0.width.height.equalTo(2 * cornerRadius)
            $0.center.equalToSuperview()
        }
        
        circleButton.snp.makeConstraints {
            $0.right.equalTo(profileImageView).offset(-5)
            $0.bottom.equalTo(profileNickNameButton.snp.top).offset(-15)
        }
        
        profileNickNameButton.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.top.equalTo(profileImageView.snp.bottom).offset(12)
            $0.centerX.equalTo(profileImageView)
        }
    }
    
    
    
    public override func bind(reactor: BibbiProfileViewReactor) {
        //TODO: 서버 통신 코드 추가 후 Reactor Binding Code 추가 예정
    }
    
}
