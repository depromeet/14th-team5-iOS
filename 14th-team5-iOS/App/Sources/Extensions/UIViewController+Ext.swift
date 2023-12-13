//
//  UIViewController+Ext.swift
//  App
//
//  Created by Kim dohyun on 12/12/23.
//

import UIKit



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
