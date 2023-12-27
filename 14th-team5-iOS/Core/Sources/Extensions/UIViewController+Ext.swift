//
//  UIViewController+Ext.swift
//  App
//
//  Created by Kim dohyun on 12/12/23.
//

import UIKit

import DesignSystem

extension UIViewController {
    enum StringLiterals {
        static let invitationUrlSharePanelTitle: String = "삐삐! 가족에게 보내는 하루 한번 생존 신고"
    }
}

extension UIViewController {
    typealias ToastView = UILabel
    
    public func makeToastView(title: String, textColor: UIColor, radius: CGFloat) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            let toastView: ToastView = UILabel()
            
            toastView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            toastView.text = title
            toastView.textColor = textColor
            toastView.textAlignment = .center
            toastView.alpha = 1.0
            toastView.font = .systemFont(ofSize: 17, weight: .regular)
            toastView.layer.cornerRadius = radius
            toastView.clipsToBounds = true
            
            
            self.view.addSubview(toastView)
            
            toastView.snp.makeConstraints {
                $0.height.equalTo(47)
                $0.width.equalTo(self.view.frame.size.width - 80)
                $0.centerX.equalToSuperview()
                $0.bottom.equalToSuperview().offset(-40)
            }
            
            
            UIView.animate(withDuration: 1.0, delay: 0.5, options: .curveEaseOut) {
                toastView.alpha = 0
            } completion: { isCompletion in
                toastView.removeFromSuperview()
            }
        }
    }
        
    /// 둥근 모양의 토스트 메시지를 보여줍니다.
    /// - Parameters:
    ///   - title: 토스트 메시지
    ///   - name: SFSymbol 이름
    ///   - pattetteColors: SFSymbol 색상 (기본값 darkGray)
    ///   - width: 너비 (기본값 250)
    ///   - height: 높이 (기본값 60)
    ///   - duration: 알림 표시 지속 시간 (기본값 0.5)
    ///   - offset: 표시할 위치 (기본값 40)
    public func makeRoundedToastView(
        title: String,
        symbol name: String,
        palletteColors colors: [UIColor] = [.darkGray],
        width: CGFloat = 250,
        height: CGFloat = 60,
        duration: CGFloat = 0.5,
        offset: CGFloat = 40
    ) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            let toastView: UIView = self.getRoundedToastView(
                title,
                symbol: name,
                palletteColors: colors,
                width: width,
                height: height,
                offset: offset
            )
            
            UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.4) {
                toastView.transform = CGAffineTransform(translationX: 0, y: -offset * 2)
            } completion: { _ in
                UIView.animate(withDuration: 0.6, delay: duration, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.4) {
                    toastView.transform = CGAffineTransform(translationX: 0, y: offset * 2)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    toastView.removeFromSuperview()
                }
            }
        }
    }
    
    /// 둥근 모양의 토스트 메시지를 보여줍니다.
    /// - Parameters:
    ///   - title: 토스트 메시지
    ///   - designSystemImage: 이미지
    ///   - width: 너비 (기본값 250)
    ///   - height: 높이 (기본값 60)
    ///   - duration: 알림 표시 지속 시간 (기본값 0.5)
    ///   - offset: 표시할 위치 (기본값 40)
    public func makeRoundedToastView(
        title: String,
        designSystemImage image: DesignSystemImages.Image,
        width: CGFloat = 250,
        height: CGFloat = 60,
        duration: CGFloat = 0.5,
        offset: CGFloat = 40
    ) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            let toastView: UIView = self.getRoundedToastView(
                title,
                designSystemImage: image,
                width: width,
                height: height,
                offset: offset
            )
            
            UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.4) {
                toastView.transform = CGAffineTransform(translationX: 0, y: -offset * 2)
            } completion: { _ in
                UIView.animate(withDuration: 0.6, delay: duration, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.4) {
                    toastView.transform = CGAffineTransform(translationX: 0, y: offset * 2)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    toastView.removeFromSuperview()
                }
            }
        }
    }
    
    private func getRoundedToastView(
        _ title: String,
        symbol name: String? = nil,
        palletteColors colors: [UIColor]? = nil,
        designSystemImage image: DesignSystemImages.Image? = nil,
        width: CGFloat,
        height: CGFloat,
        offset: CGFloat
    ) -> UIView {
        let toastView: UIView = UIView()
        let stackView: UIStackView = UIStackView()
        let labelView: UILabel = UILabel()
        var imageView: UIImageView!
        
        // SF심볼 이미지를 받았다면
        if let name = name {
            let config = UIImage.SymbolConfiguration(paletteColors: colors ?? [.darkGray])
            let symbol: UIImage? = UIImage(systemName: name, withConfiguration: config)
            
            imageView = UIImageView(image: symbol)
        // 일반 이미지를 받았다면
        } else {
            imageView = UIImageView(image: image)
        }
        
        labelView.text = title
        labelView.textColor = UIColor.white
        labelView.textAlignment = .center
        labelView.font = UIFont.systemFont(ofSize: 17)
        
        imageView.contentMode = .scaleAspectFit
        
        stackView.axis = .horizontal
        stackView.spacing = 5.0
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        
        toastView.alpha = 1.0
        toastView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toastView.layer.cornerRadius = height / 2.0
        toastView.layer.masksToBounds = true
        
        self.view.addSubview(toastView)
        toastView.addSubview(stackView)
        stackView.addArrangedSubviews(
            imageView, labelView
        )
        
        toastView.snp.makeConstraints {
            $0.height.equalTo(height)
            $0.width.equalTo(width)
            $0.bottom.equalToSuperview().offset(offset)
            $0.centerX.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(toastView.snp.leading).offset(16.0)
            $0.trailing.equalTo(toastView.snp.trailing).offset(-16.0)
            $0.centerY.equalTo(toastView.snp.centerY)
        }
        
        return toastView
    }
}

extension UIViewController {
    public func makeSharePanel(
        _ activityItemSources: [UIActivityItemSource],
        activities: [UIActivity],
        excludedActivityTypes: [UIActivity.ActivityType] = [.addToReadingList, .copyToPasteboard]
    ) {
        let items: [Any] = activityItemSources
        let activityVC = UIActivityViewController(
            activityItems: items,
            applicationActivities: activities
        )
        activityVC.excludedActivityTypes = excludedActivityTypes
        present(activityVC, animated: true)
    }
    
    /// 친구 초대 공유 시트를 보여줍니다.
    /// - Parameters:
    ///   - url: 공유할 URL
    ///   - globalState: GlobalState (선택)
    public func makeInvitationUrlSharePanel(_ url: URL?, provider globalState: GlobalStateProviderType? = nil) {
        guard let url = url else { return }
        let itemSource = UrlActivityItemSource(
            title: StringLiterals.invitationUrlSharePanelTitle,
            url: url
        )
        let copyToPastboard = CopyInvitationUrlActivity(url, provider: globalState)
        
        makeSharePanel([itemSource], activities: [copyToPastboard])
    }
}

extension UIViewController {
    /// 전달한 뷰 컨트롤러를 팝오버로 보여줍니다.
    ///
    /// 아이폰 환경에서 팝오버를 띄울 뷰 컨트롤러는 필히 `UIPopoverPresentationControllerDelegate` 프로토콜를 준수하고, 아래 메서드를 구현해야 합니다.
    /// ```swift
    /// public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
    ///     return .none
    /// }
    /// ```
    /// 아울러, 팝오버의 크기가 적절한지 직접 확인해야 합니다. 그렇지 않으면 뷰가 표시되지 않는 문제가 발생할 수 있습니다.
    ///
    /// - Parameters:
    ///   - target: Delegate 위임자
    ///   - sourceView: 팝오버를 띄울 뷰
    ///   - viewController: 팝오버 속 뷰 컨트롤러
    ///   - size: 팝오버의 사이즈
    ///   - directions: 팝오버의 화살표가 표시되는 위치
    public func makePopoverView(
        _ target: UIPopoverPresentationControllerDelegate,
        sourceView: UIView?,
        popoverViewController viewController: UIViewController,
        popoverSize size: CGSize,
        permittedArrowDrections directions: UIPopoverArrowDirection
    ) {
        let vc = viewController
        vc.preferredContentSize = size
        vc.modalPresentationStyle = .popover
        if let pres = vc.presentationController {
            pres.delegate = target
        }
        present(vc, animated: true)
        if let pop = vc.popoverPresentationController {
            pop.sourceView = sourceView
            pop.sourceRect = sourceView?.bounds ?? .zero
            pop.permittedArrowDirections = directions
        }
    }
     
    /// 한 줄 혹은 여러 줄 텍스트를 팝오버로 보여줍니다.
    ///
    /// 아이폰 환경에서 팝오버를 띄울 뷰 컨트롤러는 필히 `UIPopoverPresentationControllerDelegate` 프로토콜를 준수하고, 아래 메서드를 구현해야 합니다.
    /// ```swift
    /// public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
    ///     return .none
    /// }
    /// ```
    /// 아울러, 팝오버의 크기가 적절한지 직접 확인해야 합니다. 그렇지 않으면 뷰가 표시되지 않는 문제가 발생할 수 있습니다.
    /// `direction` 매개변수에는 `.up` 혹은` .down`만 전달해야 합니다.
    ///
    /// - Parameters:
    ///   - target: Delegate 위임자
    ///   - sourceView: 팝오버를 띄울 뷰
    ///   - text: 팝오버 속 텍스트
    ///   - size: 팝오버의 사이즈
    ///   - directions: 팝오버의 화살표가 표시되는 위치 (기본값 .down)
    public func makeDescriptionPopoverView(
        _ target: UIPopoverPresentationControllerDelegate,
        sourceView: UIView?,
        text: String,
        popoverSize size: CGSize,
        permittedArrowDrections directions: UIPopoverArrowDirection = [.down]
    ) {
        let descriptionVC = PopoverDescriptionViewController(text, arrowDirection: directions)
        makePopoverView(
            target,
            sourceView: sourceView,
            popoverViewController: descriptionVC,
            popoverSize: size,
            permittedArrowDrections: directions
        )
    }
}
