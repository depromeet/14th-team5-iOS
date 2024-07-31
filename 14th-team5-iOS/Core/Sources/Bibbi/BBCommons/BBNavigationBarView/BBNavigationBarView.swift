//
//  BBNavigationBarView.swift
//  Core
//
//  Created by 김건우 on 6/5/24.
//

import DesignSystem
import UIKit

import Then
import SnapKit
import RxSwift
import RxCocoa

///. 삐삐 스타일의 NavigationBar가 구현된 View입니다.
public final class BBNavigationBarView: UIView {
    
    // MARK: - Views
    private let containerView: UIView = UIView()
    
    private let navigationTitleLabel: BBLabel = BBLabel(.head2Bold, textColor: .gray200)
    private var navigationImageView: UIImageView = UIImageView()
    
    private let leftBarButton: UIButton = UIButton(type: .system)
    private let rightBarButton: UIButton = UIButton(type: .system)
    
    // MARK: - Properties
    public weak var delegate: BBNavigationBarViewDelegate?
    
    
    /// NavigationBar의 Title을 바꿉니다.
    /// Title을 적용하면 Image가 사라집니다.
    public var navigationTitle: String? {
        didSet {
            navigationImageView.isHidden = true
            navigationTitleLabel.isHidden = false
            
            navigationTitleLabel.text = navigationTitle
        }
    }
    
    // NavigationBar의 FontStyle을 바꿉니다.
    public var navigationTitleFontStyle: BBFontStyle = .head2Bold {
        didSet {
            navigationTitleLabel.fontStyle = navigationTitleFontStyle
        }
    }
    
    /// NavigationBar의 Image를 바꿉니다.
    /// Image를 적용하면 Title이 사라집니다.
    public var navigationImage: TopBarButtonStyle? {
        didSet {
            navigationImageView.isHidden = false
            navigationTitleLabel.isHidden = true
            
            navigationImageView.image = navigationImage?.image
        }
    }
    
    /// 왼쪽 버튼의 스타일을 설정합니다.
    public var leftBarButtonItem: TopBarButtonStyle?   {
        didSet {
            leftBarButton.setImage(
                leftBarButtonItem?.image,
                for: .normal
            )
            setupButtonBackground(leftBarButton, type: leftBarButtonItem)
        }
    }
    
    /// 오른쪽 버튼의 스타일을 설정합니다.
    public var rightBarButtonItem: TopBarButtonStyle? {
        didSet {
            rightBarButton.setImage(
                rightBarButtonItem?.image,
                for: .normal
            )
            setupButtonBackground(rightBarButton, type: leftBarButtonItem)
        }
    }
    
    /// Navigation Image의 크기를 설정합니다. 기본값은 1.0입니다.
    public var navigationImageScale: CGFloat = 1.0 {
        didSet {
            setupNavigationImageScale(navigationImageScale)
        }
    }
    
    /// 왼쪽 버튼 이미지의 크기를 설정합니다. 기본값은 1.0입니다.
    public var leftBarButtonItemScale: CGFloat = 1.0 {
        didSet {
            setupLeftButtonImageScale(leftBarButtonItemScale)
        }
    }
    
    /// 오른쪽 버튼 이미지의 크기를 설정합니다. 기본값은 1.0입니다.
    public var rightBarButtonItemScale: CGFloat = 1.0 {
        didSet {
            setupRightButtonImageScale(rightBarButtonItemScale)
        }
    }
    
    /// Navigation Title의 색상을 설정합니다.
    public var navigationTitleTextColor: UIColor = UIColor.gray200 {
        didSet {
            navigationTitleLabel.textColor = navigationTitleTextColor
        }
    }
    
    /// 왼쪽 버튼의 강조 색상을 설정합니다.
    public var leftBarButtonItemTintColor: UIColor = UIColor.gray300 {
        didSet {
            leftBarButton.tintColor = leftBarButtonItemTintColor
        }
    }
    
    /// 오른쪽 버튼의 강조 색상을 설정합니다.
    public var rightBarButtonItemTintColor: UIColor = UIColor.gray300 {
        didSet {
            rightBarButton.tintColor = rightBarButtonItemTintColor
        }
    }
    
    /// 왼쪽 버튼이 leading으로부터 얼마나 떨어져 있는지 설정합니다.
    public var leftBarButtonItemYOffset: CGFloat = 0.0 {
        didSet {
            leftBarButton.snp.updateConstraints {
                $0.leading.equalTo(leftBarButtonItemYOffset)
            }
        }
    }
    
    /// 오른쪽 버튼이 leading으로부터 얼마나 떨어져 있는지 설정합니다.
    public var rightBarButtonItemYOffset: CGFloat = 0.0 {
        didSet {
            rightBarButton.snp.updateConstraints {
                $0.trailing.equalTo(rightBarButtonItemYOffset)
            }
            rightBarButton.layoutIfNeeded()
        }
    }
    
    // MARK: - Intializer
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
        setupAutolayout()
        setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    func setupUI() {
        addSubview(containerView)
        containerView.addSubviews(
            leftBarButton, navigationImageView, navigationTitleLabel, rightBarButton
        )
    }
    
    func setupAutolayout() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        navigationImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(self.snp.width).multipliedBy(0.15)
            $0.height.equalTo(self.snp.height)
        }
        
        navigationTitleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        leftBarButton.snp.makeConstraints {
            $0.leading.equalTo(0.0)
            $0.centerY.equalTo(self.snp.centerY)
            $0.width.height.equalTo(52.0)
        }
        
        rightBarButton.snp.makeConstraints {
            $0.trailing.equalTo(0.0)
            $0.centerY.equalTo(self.snp.centerY)
            $0.width.height.equalTo(52.0)
        }
    }
    
    func setupAttributes() {
        containerView.do {
            $0.backgroundColor = UIColor.clear
        }
        
        navigationImageView.do {
            $0.contentMode = .scaleAspectFit
        }
        
        leftBarButton.do {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 10.0
            $0.tintColor = DesignSystemAsset.gray300.color
            
            $0.addTarget(
                self,
                action: #selector(didTapLeftButton),
                for: .touchUpInside
            )
            
        }
        
        rightBarButton.do {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 10.0
            $0.tintColor = DesignSystemAsset.gray300.color
            
            $0.addTarget(
                self,
                action: #selector(didTapRightButton),
                for: .touchUpInside
            )
        }
        
        setupNavigationImageScale(navigationImageScale)
        setupLeftButtonImageScale(leftBarButtonItemScale)
        setupRightButtonImageScale(rightBarButtonItemScale)
    }
}


// MARK: - Extensions

extension BBNavigationBarView {
    private func setupNavigationImageScale(_ scale: CGFloat) {
        navigationImageView.layer.transform = CATransform3DMakeScale(
            scale, scale, scale
        )
    }

    private func setupLeftButtonImageScale(_ scale: CGFloat) {
        leftBarButton.imageView?.layer.transform = CATransform3DMakeScale(
            scale, scale, scale
        )
    }

    private func setupRightButtonImageScale(_ scale: CGFloat) {
        rightBarButton.imageView?.layer.transform = CATransform3DMakeScale(
            scale, scale, scale
        )
    }

    private func setupButtonBackground(_ button: UIButton, type: TopBarButtonStyle?) {
        if type == .arrowLeft || type == .xmark {
            button.backgroundColor = .gray900
        } else {
            button.backgroundColor = .clear
        }
    }
}

extension BBNavigationBarView {
    @objc func didTapLeftButton(_ button: UIButton, event: UIButton.Event) {
        guard let _ = button.currentImage else { return }
        delegate?.navigationBarView?(button, didTapLeftBarButton: event)
    }

    @objc func didTapRightButton(_ button: UIButton, event: UIButton.Event) {
        guard let _ = button.currentImage else { return }
        delegate?.navigationBarView?(button, didTapRightBarButton: event)
    }
}
