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
public class BBNavigationBar: UIView {
    
    // MARK: - Views
    
    private let containerView = UIView()
    
    private let navigationTitleLabel = BBLabel(.head2Bold, textColor: .gray200)
    private var navigationImageView = UIImageView()
    
    private let leftBarButton = BBNavigationBarButton()
    private let rightBarButton = BBNavigationBarButton()
    
    private let newMarkImageView = UIImageView()
    
    
    // MARK: - Properties
    
    public weak var delegate: BBNavigationBarDelegate?
    
    
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
    public var navigationTitleFontStyle: BBFontStyle = .homeTitle {
        didSet {
            navigationTitleLabel.fontStyle = navigationTitleFontStyle
        }
    }
    
    /// NavigationBar의 Image를 바꿉니다.
    /// Image를 적용하면 Title이 사라집니다.
    public var navigationImage: BBNavigationTitleStyle? {
        didSet {
            navigationImageView.isHidden = false
            navigationTitleLabel.isHidden = true
            
            navigationImageView.image = navigationImage?.image
        }
    }
    
    /// 왼쪽 버튼의 스타일을 설정합니다.
    public var leftBarButtonItem: BBNavigationButtonStyle?   {
        didSet {
            setupButtonImage(leftBarButton, type: leftBarButtonItem)
            setupButtonBackground(leftBarButton, type: leftBarButtonItem)
        }
    }
    
    /// 오른쪽 버튼의 스타일을 설정합니다.
    public var rightBarButtonItem: BBNavigationButtonStyle? {
        didSet {
            setupButtonImage(rightBarButton, type: rightBarButtonItem)
            setupButtonBackground(rightBarButton, type: rightBarButtonItem)
        }
    }
    
    /// 왼쪽 버튼에 New 표시를 숨깁니다.
    public var isHiddenLeftBarButtonMark: Bool = true {
        didSet {
            leftBarButton.isHiddenMark = isHiddenLeftBarButtonMark
        }
    }
    
    // 왼쪽 버튼의 New 표시의 위치를 지정합니다.
    public var leftBarButtonMarkPosition: BBNavigationBarButton.MarkPosition = .topTrailing() {
        didSet {
            leftBarButton.markPosition = leftBarButtonMarkPosition
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

    public convenience init() {
        self.init(frame: .zero)
        commonInit()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupAutolayout()
        setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func commonInit() {
        set()
    }
    
    private func setupUI() {
        addSubview(containerView)
        containerView.addSubviews(
            leftBarButton, navigationImageView, navigationTitleLabel, rightBarButton
        )
        
        leftBarButton.addSubview(newMarkImageView)
    }
    
    private func setupAutolayout() {
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
            $0.leading.equalTo(0)
            $0.centerY.equalTo(self.snp.centerY)
            $0.width.height.equalTo(52)
        }
        
        rightBarButton.snp.makeConstraints {
            $0.trailing.equalTo(0)
            $0.centerY.equalTo(self.snp.centerY)
            $0.width.height.equalTo(52)
        }
        
        newMarkImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(7)
            $0.trailing.equalToSuperview().offset(10)
        }
    }
    
    private func setupAttributes() {
        containerView.do {
            $0.backgroundColor = .clear
        }
        
        navigationImageView.do {
            $0.contentMode = .scaleAspectFit
        }
        
        leftBarButton.do {
            $0.addTarget(
                self,
                action: #selector(didTapLeftButton),
                for: .touchUpInside
            )
            
        }
        
        rightBarButton.do {
            $0.addTarget(
                self,
                action: #selector(didTapRightButton),
                for: .touchUpInside
            )
        }
        
        newMarkImageView.do {
            $0.isHidden = true
            $0.image = DesignSystemAsset.new.image
            $0.contentMode = .scaleAspectFit
        }
        
        setupNavigationImageScale(navigationImageScale)
        setupLeftButtonImageScale(leftBarButtonItemScale)
        setupRightButtonImageScale(rightBarButtonItemScale)
    }
}


// MARK: - Extensions

extension BBNavigationBar {
    
    /// NavigationBar의 속성을 바꿉니다.
    ///
    /// - Parameters:
    ///     - title: 네비게이션 바의 타이틀 문자열
    ///     - titleColor: 네비게이션 바의 타이틀 색상
    ///     - titleFontStyle: 네비게이션 바의 타이틀 폰트 스타일
    ///     - leftBarButtonItem: 네비게이션 바의 왼쪽 버튼 스타일
    ///     - leftBarButtonTint: 네비게이션 바의 왼쪽 버튼 강조 색상
    ///     - leftBarButtonItemScale: 네비게이션 바의 왼쪽 버튼 크기
    ///     - leftBarButtonYOffset: 네비게이션 바의 왼쪽 버튼 Y 위치
    ///     - rightBarButtonItem: 네비게이션 바의 오른쪽 버튼 스타일
    ///     - rightBarButtonTint: 네비게이션 바의 오른쪽 버튼 강조 색상
    ///     - rightBarButtonItemScale: 네비게이션 바의 오른쪽 버튼 크기
    ///     - rightBarButtonYOffset: 네비게이션 바의 오른쪽 버튼 Y 위치
    public func set(
        _ title: String? = "Bibbi",
        titleColor: UIColor = .gray200,
        titleFontStyle: BBFontStyle = .homeTitle,
        leftBarButtonItem: BBNavigationButtonStyle? = nil,
        leftBarButtonTint: UIColor = .gray300,
        leftBarButtonItemScale: CGFloat = 1.0,
        leftBarButtonYOffset: CGFloat = 0.0,
        rightBarButtonItem: BBNavigationButtonStyle? = nil,
        rightBarButtonTint: UIColor = .gray300,
        rightBarButtonItemScale: CGFloat = 1.0,
        rightBarButtonYOffset: CGFloat = 0.0
    ) {
        self.navigationTitle = title
        self.navigationTitleTextColor = titleColor
        self.navigationTitleFontStyle = titleFontStyle
        
        setAttributes(
            leftBarButtonItem: leftBarButtonItem,
            leftBarButtonTint: leftBarButtonTint,
            leftBarButtonItemScale: leftBarButtonItemScale,
            leftBarButtonYOffset: leftBarButtonYOffset,
            rightBarButtonItem: rightBarButtonItem,
            rightBarButtonTint: rightBarButtonTint,
            rightBarButtonItemScale: rightBarButtonItemScale,
            rightBarButtonYOffset: rightBarButtonYOffset
        )
    }
    
    /// NavigationBar의 속성을 바꿉니다.
    ///
    /// - Parameters:
    ///     - title: 네비게이션 바의 타이틀 문자열
    ///     - titleColor: 네비게이션 바의 타이틀 색상
    ///     - titleFontStyle: 네비게이션 바의 타이틀 폰트 스타일
    ///     - leftBarButtonItem: 네비게이션 바의 왼쪽 버튼 스타일
    ///     - leftBarButtonTint: 네비게이션 바의 왼쪽 버튼 강조 색상
    ///     - leftBarButtonItemScale: 네비게이션 바의 왼쪽 버튼 크기
    ///     - leftBarButtonYOffset: 네비게이션 바의 왼쪽 버튼 Y 위치
    ///     - rightBarButtonItem: 네비게이션 바의 오른쪽 버튼 스타일
    ///     - rightBarButtonTint: 네비게이션 바의 오른쪽 버튼 강조 색상
    ///     - rightBarButtonItemScale: 네비게이션 바의 오른쪽 버튼 크기
    ///     - rightBarButtonYOffset: 네비게이션 바의 오른쪽 버튼 Y 위치
    public func set(
        _ image: BBNavigationTitleStyle? = nil,
        imageScale: CGFloat = 1.0,
        leftBarButtonItem: BBNavigationButtonStyle? = nil,
        leftBarButtonTint: UIColor = .gray300,
        leftBarButtonItemScale: CGFloat = 1.0,
        leftBarButtonYOffset: CGFloat = 0.0,
        rightBarButtonItem: BBNavigationButtonStyle? = nil,
        rightBarButtonTint: UIColor = .gray300,
        rightBarButtonItemScale: CGFloat = 1.0,
        rightBarButtonYOffset: CGFloat = 0.0
    ) {
        self.navigationImage = image
        self.navigationImageScale = imageScale
        
        setAttributes(
            leftBarButtonItem: leftBarButtonItem,
            leftBarButtonTint: leftBarButtonTint,
            leftBarButtonItemScale: leftBarButtonItemScale,
            leftBarButtonYOffset: leftBarButtonYOffset,
            rightBarButtonItem: rightBarButtonItem,
            rightBarButtonTint: rightBarButtonTint,
            rightBarButtonItemScale: rightBarButtonItemScale,
            rightBarButtonYOffset: rightBarButtonYOffset
        )
    }
    
    private func setAttributes(
        leftBarButtonItem: BBNavigationButtonStyle? = nil,
        leftBarButtonTint: UIColor = .gray300,
        leftBarButtonItemScale: CGFloat = 1.0,
        leftBarButtonYOffset: CGFloat = 0.0,
        rightBarButtonItem: BBNavigationButtonStyle? = nil,
        rightBarButtonTint: UIColor = .gray300,
        rightBarButtonItemScale: CGFloat = 1.0,
        rightBarButtonYOffset: CGFloat = 0.0
    ) {
        self.leftBarButtonItem = leftBarButtonItem
        self.leftBarButtonItemTintColor = leftBarButtonTint
        self.leftBarButtonItemScale = leftBarButtonItemScale
        self.leftBarButtonItemYOffset = leftBarButtonYOffset
        
        self.rightBarButtonItem = rightBarButtonItem
        self.rightBarButtonItemTintColor = rightBarButtonTint
        self.rightBarButtonItemScale = rightBarButtonItemScale
        self.rightBarButtonItemYOffset = rightBarButtonYOffset
    }
    
}

extension BBNavigationBar {
    
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
    
    private func setupButtonImage(
        _ button: BBNavigationBarButton,
        type: BBNavigationButtonStyle?
    ) {
        button.type = type
        if case let .person(new) = type {
            button.isHiddenMark = !new
        }
    }

    private func setupButtonBackground(
        _ button: BBNavigationBarButton,
        type: BBNavigationButtonStyle?
    ) {
        if type == .arrowLeft || type == .xmark {
            button.backgroundColor = .gray900
        } else {
            button.backgroundColor = .clear
        }
    }
    
}

extension BBNavigationBar {
    
    @objc func didTapLeftButton(_ button: UIButton, event: UIButton.Event) {
        guard let _ = button.currentImage else { return }
        delegate?.navigationBar?(button, didTapLeftBarButton: event)
    }

    @objc func didTapRightButton(_ button: UIButton, event: UIButton.Event) {
        guard let _ = button.currentImage else { return }
        delegate?.navigationBar?(button, didTapRightBarButton: event)
    }
    
}
