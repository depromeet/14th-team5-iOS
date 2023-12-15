//
//  UIViewController+Ext.swift
//  App
//
//  Created by Kim dohyun on 12/12/23.
//

import UIKit

import Core

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
}

extension UIViewController {
    func makeSharePanel(
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
    
    func makeInvitationUrlSharePanel(_ url: URL?, provider globalState: GlobalStateProviderType? = nil) {
        guard let url = url else { return }
        let itemSource = UrlActivityItemSource(
            title: StringLiterals.invitationUrlSharePanelTitle,
            url: url
        )
        let copyToPastboard = CopyInvitationUrlActivity(provider: globalState)
        
        UIPasteboard.general.string = url.description
        makeSharePanel([itemSource], activities: [copyToPastboard])
    }
}

extension UIViewController {
    func makePopoverView(
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
            pop.permittedArrowDirections = [.down]
        }
    }
    
    func makeDescriptionPopoverView(
        _ target: UIPopoverPresentationControllerDelegate,
        sourceView: UIView?,
        text: String,
        popoverSize size: CGSize,
        permittedArrowDrections directions: UIPopoverArrowDirection = [.down]
    ) {
        let descriptionVC = PopoverDescriptionViewController(text: text)
        makePopoverView(
            target,
            sourceView: sourceView,
            popoverViewController: descriptionVC,
            popoverSize: size,
            permittedArrowDrections: directions
        )
    }
}
