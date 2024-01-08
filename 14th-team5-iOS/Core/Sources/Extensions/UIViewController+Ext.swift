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
    ///   - text: 토스트 메시지
    ///   - name: SFSymbol 이름
    ///   - pattetteColors: SFSymbol 색상 (기본값 .gray300)
    ///   - width: 너비 (기본값 250)
    ///   - height: 높이 (기본값 56)
    ///   - duration: 알림 표시 지속 시간 (기본값 0.5)
    ///   - offset: 표시할 위치 (기본값 40)
    public func makeBibbiToastView(
        text: String,
        symbol name: String = "",
        palletteColors: [UIColor] = [.gray300],
        backgroundColor: UIColor = .gray900,
        width: CGFloat = 250,
        height: CGFloat = 56,
        duration: CGFloat = 0.5,
        offset: CGFloat = 40
    ) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            guard let toastView = self.prepareBibbiToastView(
                text: text,
                symbol: name,
                palletteColors: palletteColors,
                backgroundColor: backgroundColor,
                width: width,
                height: height,
                offset: offset
            ) else {
                return
            }
            
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
    ///   - text: 토스트 메시지
    ///   - designSystemImage: 이미지
    ///   - width: 너비 (기본값 250)
    ///   - height: 높이 (기본값 56)
    ///   - duration: 알림 표시 지속 시간 (기본값 0.5)
    ///   - offset: 표시할 위치 (기본값 40)
    public func makeBibbiToastView(
        text: String,
        designSystemImage image: DesignSystemImages.Image,
        backgroundColor: UIColor = .gray900,
        width: CGFloat = 250,
        height: CGFloat = 56,
        duration: CGFloat = 0.5,
        offset: CGFloat = 40
    ) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            guard let toastView = self.prepareBibbiToastView(
                text: text,
                designSystemImage: image,
                backgroundColor: backgroundColor,
                width: width,
                height: height,
                offset: offset
            ) else {
                return
            }
            
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
    
    private func prepareBibbiToastView(
        text: String,
        symbol name: String? = nil,
        palletteColors colors: [UIColor]? = nil,
        designSystemImage image: DesignSystemImages.Image? = nil,
        backgroundColor: UIColor = .gray900,
        width: CGFloat,
        height: CGFloat,
        offset: CGFloat
    ) -> UIView? {
        // 하위 뷰에 이미 ToastView가 존재한다면
        guard view.findSubview(of: BibbiToastMessageView.self) == nil else {
            return nil
        }
        
        let image: UIImage? = {
            if let name = name {
                let colors: [UIColor] = colors ?? [.gray300]
                let config = UIImage.SymbolConfiguration(paletteColors: colors)
                return UIImage(systemName: name, withConfiguration: config)
            } else {
                return image
            }
        }()
        
        let toastView: BibbiToastMessageView = BibbiToastMessageView(
            text: text,
            image: image,
            containerColor: backgroundColor,
            width: width,
            height: height
        )
        
        self.view.addSubview(toastView)
        toastView.snp.makeConstraints {
            $0.width.equalTo(width)
            $0.height.equalTo(height)
            $0.bottom.equalToSuperview().offset(offset)
            $0.centerX.equalToSuperview()
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
    public func makeInvitationUrlSharePanel(_ url: URL?, provider globalState: GlobalStateProviderProtocol? = nil) {
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

extension UIViewController {
    public func calculateRemainingTime() -> Int {
        let calendar = Calendar.current
        let currentTime = Date()
        
        let isAfterNoon = calendar.component(.hour, from: currentTime) >= 12
        
        if isAfterNoon {
            if let nextMidnight = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: currentTime.addingTimeInterval(24 * 60 * 60)) {
                let timeDifference = calendar.dateComponents([.second], from: currentTime, to: nextMidnight)
                return max(0, timeDifference.second ?? 0)
            }
        }
        
        return 0
    }
}
