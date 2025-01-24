//
//  ResignReaonsTableViewCell.swift
//  App
//
//  Created by 김도현 on 11/21/24.
//

import UIKit

import Core
import DesignSystem



final class ResignReaonsTableViewCell: BaseTableViewCell<ResignReasonTableViewCellReactor> {
    private let checkBoxButton: UIButton = UIButton(type: .custom)
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override func setupUI() {
        contentView.addSubview(checkBoxButton)
    }
    
    override func setupAttributes() {
        
        self.do {
            $0.backgroundColor = .clear
            $0.selectionStyle = .none
        }
        
        checkBoxButton.do {
            $0.configuration = .plain()
            $0.configuration?.baseBackgroundColor = .clear
            $0.configuration?.imagePadding = 10
            $0.configuration?.imagePlacement = .leading
            $0.isUserInteractionEnabled = false
        }
    }
    
    
    override func setupAutoLayout() {
        checkBoxButton.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.top.equalToSuperview().inset(14)
            $0.centerY.equalToSuperview()
        }
    }
    
    override func bind(reactor: Reactor) {
        reactor.state
            .map { $0.reasonType.title }
            .distinctUntilChanged()
            .bind(with: self) { owner, content in
                owner.checkBoxButton.configuration?.attributedTitle = AttributedString(NSAttributedString(string: content, attributes: [
                    .foregroundColor: DesignSystemAsset.gray200.color,
                    .font: DesignSystemFontFamily.Pretendard.regular.font(size: 16),
                    .kern: -0.3
                ]))
            }
            .disposed(by: disposeBag)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        checkBoxButton.configuration?.image = selected ? DesignSystemAsset.checkBox.image : DesignSystemAsset.uncheckBox.image
    }
}
