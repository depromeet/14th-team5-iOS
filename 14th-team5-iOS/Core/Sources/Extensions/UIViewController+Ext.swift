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
    
    @available(*, deprecated, message: "BBToast를 사용하세요.")
    public enum ToastDirection {
        case up
        case down
    }
    
    @available(*, deprecated, message: "BBToast를 사용하세요.")
    public func makeErrorBibbiToastView(
        delay: CGFloat = 0.6,
        duration: CGFloat = 0.6,
        offset: CGFloat = 40,
        direction: ToastDirection = .up
    ) {
        makeBibbiToastView(
            text: "잠시 후에 다시 시도해주세요",
            image: DesignSystemAsset.warning.image,
            offset: offset,
            direction: direction
        )
    }
    
    @available(*, deprecated, message: "BBToast를 사용하세요.")
    public func makeActionBibbiToastView(
        text: String = "",
        transtionText: String = "",
        duration: CGFloat = 0.6,
        offset: CGFloat = 40,
        direction: ToastDirection = .up
    ) {
        makeTranstionToastView(
            text: text,
            transtionText: transtionText,
            image: DesignSystemAsset.warning.image,
            duration: duration,
            offset: offset,
            direction: direction
        )
    }
    
    @available(*, deprecated, message: "BBToast를 사용하세요.")
    public func makeTranstionToastView(
        text: String = "",
        transtionText: String = "",
        image: DesignSystemImages.Image? = nil,
        duration: CGFloat = 0.6,
        offset: CGFloat = 40,
        direction: ToastDirection = .up
    ) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            guard let toastView = self.prepareBibbiToastView(text: text, transtionText: transtionText, image: image, offset: offset, animation: direction) else { return }
            
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.4) {
                if direction == .up {
                    toastView.transform = CGAffineTransform(translationX: 0, y: -offset * 2)
                } else {
                    toastView.transform = CGAffineTransform(translationX: 0, y: offset * 2)
                }
            }
        }
    }
    
    @available(*, deprecated, message: "BBToast를 사용하세요.")
    public func makeBibbiToastView(
        text: String,
        image: DesignSystemImages.Image? = nil,
        transtionText: String = "",
        duration: CGFloat = 0.6,
        delay: CGFloat = 0.6,
        offset: CGFloat = 40,
        direction: ToastDirection = .up
    ) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            guard let toastView = self.prepareBibbiToastView(
                text: text,
                transtionText: transtionText,
                image: image,
                offset: offset,
                animation: direction
            ) else {
                return
            }
            
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.4) {
                if direction == .up {
                    toastView.transform = CGAffineTransform(translationX: 0, y: -offset * 2)
                } else {
                    toastView.transform = CGAffineTransform(translationX: 0, y: offset * 2)
                }
            } completion: { _ in
                UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.4) {
                    if direction == .up {
                        toastView.transform = CGAffineTransform(translationX: 0, y: offset * 2)
                    } else {
                        toastView.transform = CGAffineTransform(translationX: 0, y: -offset * 2)
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + duration * 2) {
                    toastView.removeFromSuperview()
                }
            }
        }
    }
    
    private func prepareBibbiToastView(
        text: String,
        transtionText: String,
        image: DesignSystemImages.Image? = nil,
        offset: CGFloat,
        animation: ToastDirection
    ) -> UIView? {
        // 하위 뷰에 이미 ToastView가 존재한다면
        guard view.findSubview(of: BibbiToastMessageView.self) == nil else {
            return nil
        }
        
        let toastView = BibbiToastMessageView(transtionText: transtionText, text: text, image: image)
        
        self.view.addSubview(toastView)
        toastView.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.horizontalEdges.equalToSuperview()
            if animation == .up {
                $0.bottom.equalToSuperview().offset(offset)
            } else {
                $0.top.equalToSuperview().offset(-offset)
            }
        }
        
        return toastView
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
    
    public enum CommentSheetType {
        case post
        case calendar
    }
    
    public func presentSheet(
        _ viewController: UIViewController,
        allowMediumDetent: Bool
    ) {
        let detents: [UISheetPresentationController.Detent] = if allowMediumDetent {
            [.medium(), .large()]
        } else {
            [.large()]
        }
        presentSheet(
            viewController,
            detents: detents
        )
    }
    
    public func presentSheet(
        _ viewController: UIViewController,
        detents: [UISheetPresentationController.Detent]?,
        prefersScrollingExpandsWhenScrolledToEdge expands: Bool = false,
        prefersGrabberVisible grabber: Bool = false
    ) {
        if let sheet = viewController.sheetPresentationController {
            if let detents = detents {
                sheet.detents = detents
            }
            sheet.prefersScrollingExpandsWhenScrolledToEdge = expands
            sheet.prefersGrabberVisible = grabber
        }
        
        present(viewController, animated: true)
    }
    
    @available(iOS 16.0, *)
    public func presentSheet(
        _ viewController: UIViewController,
        detentHeightRatio ratios: [CGFloat],
        allowLargeDetent: Bool = false,
        prefersScrollingExpandsWhenScrolledToEdge expands: Bool = false,
        prefersGrabberVisble grabber: Bool = false
    ) {
        var customHeightDetents: [UISheetPresentationController.Detent] = []
        
        ratios.forEach { ratio in
            let identifier = UISheetPresentationController.Detent.Identifier("\(ratio).identifier")
            let customDetent = UISheetPresentationController.Detent.custom(identifier: identifier) { context in
                return context.maximumDetentValue * ratio
            }
            customHeightDetents.append(customDetent)
        }
        
        let detents = if allowLargeDetent {
            customHeightDetents + [.large()]
        } else {
            customHeightDetents
        }
        
        presentSheet(
            viewController,
            detents: detents,
            prefersScrollingExpandsWhenScrolledToEdge: expands,
            prefersGrabberVisible: grabber
        )
    }
    
    /// 댓글 목록 화면을 시트로 출력하기 위한 메서드입니다.
    ///
    /// - parameter postCommentViewController: PostCommentViewController 타입의 뷰 컨트롤러
    public func presentPostCommentSheet(
        _ postCommentViewController: UIViewController,
        from type: UIViewController.CommentSheetType
    ) {
        var ratio: CGFloat = switch type {
        case .post: 0.85
        case .calendar: UIScreen.isPhoneSE ? 0.815 : 0.835
        }
        
        if #available(iOS 16.0, *) {
            presentSheet(
                postCommentViewController,
                detentHeightRatio: [ratio],
                allowLargeDetent: true
            )
        } else {
            presentSheet(
                postCommentViewController,
                allowMediumDetent: true
            )
        }
    }
}
