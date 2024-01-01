//
//  BibbiNavigationTopBarView.swift
//  Core
//
//  Created by 김건우 on 12/31/23.
//

import UIKit

import DesignSystem
import Then
import SnapKit

import RxSwift
import RxCocoa

public final class BibbiNavigationBarView: UIView {
    // MARK: - Views
    private let backgroundView: UIView = UIView()
    
    private let navigationTitleLabel: BibbiLabel = BibbiLabel(.head2Bold, textColor: .gray200)
    private var navigationImageView: UIImageView = UIImageView()
    
    private let leftBarButton: UIButton = UIButton(type: .system)
    private let rightBarButton: UIButton = UIButton(type: .system)
    
    // MARK: - Properties
    weak public var delegate: BibbiNavigationBarViewDelegate?
    
    public var navigationTitle: String? {
        didSet {
            navigationImageView.isHidden = true
            navigationTitleLabel.isHidden = false
            
            navigationTitleLabel.text = navigationTitle
        }
    }
    
    public var navigationImage: UIImage.TopBarImageType? {
        didSet {
            navigationImageView.isHidden = false
            navigationTitleLabel.isHidden = true
            
            navigationImageView.image = navigationImage?.barImage
        }
    }
    
    public var leftBarButtonItem: UIImage.TopBarIconType?   {
        didSet {
            leftBarButton.setImage(
                leftBarButtonItem?.barButtonImage,
                for: .normal
            )
            setupButtonBackground(leftBarButton, type: leftBarButtonItem)
        }
    }
    
    public var rightBarButtonItem: UIImage.TopBarIconType? {
        didSet {
            rightBarButton.setImage(
                rightBarButtonItem?.barButtonImage,
                for: .normal
            )
            setupButtonBackground(rightBarButton, type: leftBarButtonItem)
        }
    }
    
    public var navigationImageScale: CGFloat = 1.0 {
        didSet {
            setupNavigationImageScale(navigationImageScale)
        }
    }
    
    public var leftBarButtonItemScale: CGFloat = 1.0 {
        didSet {
            setupLeftButtonImageScale(leftBarButtonItemScale)
        }
    }
    
    public var rightBarButtonItemScale: CGFloat = 1.0 {
        didSet {
            setupRightButtonImageScale(rightBarButtonItemScale)
        }
    }
    
    public var navigationTitleTextColor: UIColor = UIColor.gray200 {
        didSet {
            navigationTitleLabel.textColor = navigationTitleTextColor
        }
    }
    
    public var leftBarButtonItemTintColor: UIColor = UIColor.gray300 {
        didSet {
            leftBarButton.tintColor = leftBarButtonItemTintColor
        }
    }
    
    public var rightBarButtonItemTintColor: UIColor = UIColor.gray300 {
        didSet {
            rightBarButton.tintColor = rightBarButtonItemTintColor
        }
    }
    
    public var leftBarButtonItemYOffset: CGFloat = 0.0 {
        didSet {
            leftBarButton.snp.updateConstraints {
                $0.leading.equalTo(leftBarButtonItemYOffset)
            }
        }
    }
    
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
        addSubview(backgroundView)
        backgroundView.addSubviews(
            leftBarButton, navigationImageView, navigationTitleLabel, rightBarButton
        )
    }
    
    func setupAutolayout() {
        backgroundView.snp.makeConstraints {
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
        backgroundView.do {
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
extension BibbiNavigationBarView {
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
    
    private func setupButtonBackground(_ button: UIButton, type: UIImage.TopBarIconType?) {
        if type == .arrowLeft || type == .xmark {
            button.backgroundColor = .gray900
        } else {
            button.backgroundColor = .clear
        }
    }
}

extension BibbiNavigationBarView {
    @objc func didTapLeftButton(_ button: UIButton, event: UIButton.Event) {
        guard let _ = button.currentImage else { return }
        delegate?.navigationBarView?(button, didTapLeftBarButton: event)
    }
    
    @objc func didTapRightButton(_ button: UIButton, event: UIButton.Event) {
        guard let _ = button.currentImage else { return }
        delegate?.navigationBarView?(button, didTapRightBarButton: event)
    }
}
