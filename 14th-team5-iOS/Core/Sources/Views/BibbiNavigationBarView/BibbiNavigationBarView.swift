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
    private let containerView: UIView = UIView()
    
    private let navigationTitleLabel: BibbiLabel = BibbiLabel(.head2Bold, textColor: .gray200)
    private var navigationImageView: UIImageView = UIImageView()
    
    fileprivate let leftBarButton: UIButton = UIButton(type: .system)
    fileprivate let rightBarButton: UIButton = UIButton(type: .system)
    
    private let disposeBag = DisposeBag()
    
    var leftBarItem: LeftBarItem?
    
    // MARK: - Properties
//    weak public var delegate: BibbiNavigationBarViewDelegate?
    
//    public var navigationTitle: String? {
//        didSet {
//            navigationImageView.isHidden = true
//            navigationTitleLabel.isHidden = false
//            
//            navigationTitleLabel.text = navigationTitle
//        }
//    }
    
//    public var navigationImage: UIImage.TopBarImageType? {
//        didSet {
//            navigationImageView.isHidden = false
//            navigationTitleLabel.isHidden = true
//            
//            navigationImageView.image = navigationImage?.barImage
//        }
//    }
    
//    public var leftBarButtonItem: UIImage.TopBarIconType?   {
//        didSet {
//            leftBarButton.setImage(
//                leftBarButtonItem?.barButtonImage,
//                for: .normal
//            )
////            setupButtonBackground(leftBarButton, type: leftBarButtonItem)
//        }
//    }
    
//    public var rightBarButtonItem: UIImage.TopBarIconType? {
//        didSet {
//            rightBarButton.setImage(
//                rightBarButtonItem?.barButtonImage,
//                for: .normal
//            )
////            setupButtonBackground(rightBarButton, type: leftBarButtonItem)
//        }
//    }
//    
//    public var navigationImageScale: CGFloat = 1.0 {
//        didSet {
//            setupNavigationImageScale(navigationImageScale)
//        }
//    }
//    
//    public var leftBarButtonItemScale: CGFloat = 1.0 {
//        didSet {
//            setupLeftButtonImageScale(leftBarButtonItemScale)
//        }
//    }
//    
//    public var rightBarButtonItemScale: CGFloat = 1.0 {
//        didSet {
//            setupRightButtonImageScale(rightBarButtonItemScale)
//        }
//    }
//    
//    public var navigationTitleTextColor: UIColor = UIColor.gray200 {
//        didSet {
//            navigationTitleLabel.textColor = navigationTitleTextColor
//        }
//    }
    
//    public var leftBarButtonItemTintColor: UIColor = UIColor.gray300 {
//        didSet {
//            leftBarButton.tintColor = leftBarButtonItemTintColor
//        }
//    }
//    
//    public var rightBarButtonItemTintColor: UIColor = UIColor.gray300 {
//        didSet {
//            rightBarButton.tintColor = rightBarButtonItemTintColor
//        }
//    }
//    
//    public var leftBarButtonItemYOffset: CGFloat = 0.0 {
//        didSet {
//            leftBarButton.snp.updateConstraints {
//                $0.leading.equalTo(leftBarButtonItemYOffset)
//            }
//        }
//    }
//    
//    public var rightBarButtonItemYOffset: CGFloat = 0.0 {
//        didSet {
//            rightBarButton.snp.updateConstraints {
//                $0.trailing.equalTo(rightBarButtonItemYOffset)
//            }
//            rightBarButton.layoutIfNeeded()
//        }
//    }
//    
//    public var hiddenLeftBarButtonBackground: Bool? {
//        didSet {
//            if let hidden = hiddenLeftBarButtonBackground {
//                if hidden {
//                    leftBarButton.backgroundColor = UIColor.clear
//                } else {
//                    leftBarButton.backgroundColor = UIColor.gray900
//                }
//            }
//        }
//    }
//    
//    public var hiddenRightBarButtonBackground: Bool? {
//        didSet {
//            if let hidden = hiddenRightBarButtonBackground {
//                if hidden {
//                    rightBarButton.backgroundColor = UIColor.clear
//                } else {
//                    rightBarButton.backgroundColor = UIColor.gray900
//                }
//            }
//        }
//    }
    
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
    
    private func setupAutolayout() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        navigationImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.15)
            $0.height.equalToSuperview()
        }
        
        navigationTitleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        leftBarButton.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
//            $0.centerY.equalToSuperview()
            $0.size.equalTo(52.0)
        }
        
        rightBarButton.snp.makeConstraints {
            $0.trailing.top.equalToSuperview()
//            $0.centerY.equalToSuperview()
            $0.size.equalTo(52.0)
        }
    }
    
    private func setupAttributes() {
        containerView.do {
            $0.backgroundColor = UIColor.clear
        }
        
        navigationImageView.do {
            $0.contentMode = .scaleAspectFit
        }
        
        leftBarButton.do {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 10.0
            $0.tintColor = .gray300
//            
//            $0.addTarget(
//                self,
//                action: #selector(didTapLeftButton),
//                for: .touchUpInside
//            )
//            
        }
        
        rightBarButton.do {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 10.0
            $0.tintColor = .gray300
//            $0.contentScaleFactor = 2.0
//
//            $0.addTarget(
//                self,
//                action: #selector(didTapRightButton),
//                for: .touchUpInside
//            )
        }
        
//        setupNavigationImageScale(navigationImageScale)
//        setupLeftButtonImageScale(leftBarButtonItemScale)
//        setupRightButtonImageScale(rightBarButtonItemScale)
    }
}

// MARK: - Extensions
extension BibbiNavigationBarView {
//    private func setupNavigationImageScale(_ scale: CGFloat) {
//        navigationImageView.layer.transform = CATransform3DMakeScale(
//            scale, scale, scale
//        )
//    }
//    
//    private func setupLeftButtonImageScale(_ scale: CGFloat) {
//        leftBarButton.imageView?.layer.transform = CATransform3DMakeScale(
//            scale, scale, scale
//        )
//    }
//    
//    private func setupRightButtonImageScale(_ scale: CGFloat) {
//        rightBarButton.imageView?.layer.transform = CATransform3DMakeScale(
//            scale, scale, scale
//        )
//    }
    
//    private func setupButtonBackground(type: UIImage.TopBarIconType?) {
//        if type == .arrowLeft || type == .xmark {
//            button.backgroundColor = .gray900
//        } else {
//            button.backgroundColor = .clear
//        }
//    }
}

//extension BibbiNavigationBarView {
//    @objc func didTapLeftButton(_ button: UIButton, event: UIButton.Event) {
//        guard let _ = button.currentImage else { return }
//        delegate?.navigationBarView?(button, didTapLeftBarButton: event)
//    }
//    
//    @objc func didTapRightButton(_ button: UIButton, event: UIButton.Event) {
//        guard let _ = button.currentImage else { return }
//        delegate?.navigationBarView?(button, didTapRightBarButton: event)
//    }
//}

//public final class NavigationBarButton: UIButton {
//    let type: LeftBarButton
//}
public enum LeftBarItem: Equatable {
    case xmark
    case arrowLeft
    case family
    
    var backgroundColor: UIColor {
        switch self {
        case .xmark, .arrowLeft: return .gray900
        default: return .clear
        }
    }
    
    var image: UIImage {
        switch self {
        case .arrowLeft: return DesignSystemAsset.arrowLeft.image
        case .xmark: return DesignSystemAsset.xmark.image
        case .family: return DesignSystemAsset.addPerson.image
        }
    }
}

extension BibbiNavigationBarView {
    
    
    public enum CenterBarItem: Equatable {
        case logo
        case label(String?)
        
        var title: String? {
            switch self {
            case .label(let title): return title
            default: return nil
            }
        }
        
        var logo: UIImage? {
            switch self {
            case .logo: return DesignSystemAsset.bibbiLogo.image
            default: return nil
            }
        }
    }

    public enum RightBarItem {
        case empty
        case setting
        case calendar
        
        var image: UIImage? {
            switch self {
            case .setting: return DesignSystemAsset.setting.image
            case .calendar: return DesignSystemAsset.heartCalendar.image
            default: return nil
            }
        }
    }
    
    public func setNavigationView(leftItem: LeftBarItem, centerItem: CenterBarItem? = nil, rightItem: RightBarItem) {
        leftBarButton.setImage(leftItem.image, for: .normal)
        rightBarButton.setImage(rightItem.image, for: .normal)
        leftBarButton.backgroundColor = leftItem.backgroundColor
        
        self.leftBarItem = leftItem
        self.navigationImageView.image = centerItem?.logo
        self.navigationTitleLabel.text = centerItem?.title
    }
    
    public func setNavigationTitle(title: String) {
        self.navigationTitleLabel.text = title
    }
}

extension Reactive where Base: BibbiNavigationBarView {
   public  var leftButtonTap: ControlEvent<LeftBarItem?> {
        let source = base.leftBarButton.rx.tap
            .withUnretained(base)
            .map { $0.0.leftBarItem }
            .throttle(RxConst.throttleInterval, scheduler: MainScheduler.instance)
        
        return ControlEvent(events: source)
    }
    
    public var rightButtonTap: ControlEvent<Void> {
        let source = base.rightBarButton.rx.tap
            .throttle(RxConst.throttleInterval, scheduler: MainScheduler.instance)

        return ControlEvent(events: source)
    }
}
