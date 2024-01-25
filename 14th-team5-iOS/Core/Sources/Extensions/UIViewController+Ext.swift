//
//  UIViewController+Ext.swift
//  App
//
//  Created by Kim dohyun on 12/12/23.
//

import DesignSystem
import UIKit

import SnapKit
import Then

extension UIViewController {
    public func makeBibbiToastView(
        text: String,
        image: DesignSystemImages.Image? = nil,
        duration: CGFloat = 0.6,
        delay: CGFloat = 0.6,
        offset: CGFloat = 40
    ) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            guard let toastView = self.prepareBibbiToastView(
                text: text,
                image: image,
                offset: offset
            ) else {
                return
            }
            
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.4) {
                toastView.transform = CGAffineTransform(translationX: 0, y: -offset * 2)
            } completion: { _ in
                UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.4) {
                    toastView.transform = CGAffineTransform(translationX: 0, y: offset * 2)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + duration * 2) {
                    toastView.removeFromSuperview()
                }
            }
        }
    }
    
    private func prepareBibbiToastView(
        text: String,
        image: DesignSystemImages.Image? = nil,
        offset: CGFloat
    ) -> UIView? {
        // 하위 뷰에 이미 ToastView가 존재한다면
        guard view.findSubview(of: BibbiToastMessageView.self) == nil else {
            return nil
        }
        
        let toastView = BibbiToastMessageView(text: text, image: image)
        
        self.view.addSubview(toastView)
        toastView.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().offset(offset)
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
            title: "삐삐! 가족에게 보내는 하루 한번 생존 신고",
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
