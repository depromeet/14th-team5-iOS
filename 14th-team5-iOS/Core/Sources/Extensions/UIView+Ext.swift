//
//  UIView+Ext.swift
//  App
//
//  Created by 마경미 on 05.12.23.
//

import UIKit

extension UIView {
    
    /// 여러 `UIView`를 추가합니다.
    /// - Parameter views: 가변 크기의 UIView입니다.
    public func addSubviews(_ views: UIView...) {
        views.forEach {
            self.addSubview($0)
        }
    }
    
    /// 여러 `UIView`를 앞으로 다시 배치합니다.
    /// - Parameter views: 가변 크기의 UIView입니다.
    public func bringSubviewToFronts(_ views: UIView...) {
        views.forEach {
            self.bringSubviewToFront($0)
        }
    }
}

extension UIView {
    
    @available(*, deprecated, message: "삭제")
    public func findSubview<T: UIView>(of type: T.Type) -> T? {
        if let test = subviews.first(where: { $0 is T }) as? T {
            return test
        } else {
            for view in subviews {
                return view.findSubview(of: type)
            }
        }
        return nil
    }
    
    @available(*, deprecated, message: "삭제")
    public func asImage() -> UIImage {
           let renderer = UIGraphicsImageRenderer(bounds: bounds)
           return renderer.image { rendererContext in
               layer.render(in: rendererContext.cgContext)
           }
       }
}

extension UIView {
    
    @available(*, deprecated, renamed: "setBlurEffect")
    public func addBlurEffect(style: UIBlurEffect.Style) {
        let blurEffect = UIBlurEffect(style: style)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = self.frame
        self.addSubview(visualEffectView)
    }
    
    /// 해당 `UIView`에 블러 효과를 적용합니다.
    /// - Parameter style: `UIBlurEffect.Style` 타입의 스타일입니다.
    public func setBlurEffect(style: UIBlurEffect.Style) {
        let blurEffect = UIBlurEffect(style: style)
        let effectView = UIVisualEffectView(effect: blurEffect)
        effectView.frame = self.bounds
        effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.insertSubview(effectView, at: 0)
    }
    
}


extension UIImageView {
    
    public var isShimmering: Bool {
        get {
            return layer.mask?.animation(forKey: shimmerAnimationKey) != nil
        } set {
            if newValue {
                startShimmering()
            } else {
                stopShimmering()
            }
        }
    }
    
    private var shimmerAnimationKey: String {
        return "shimmer"
    }
    
    private func startShimmering() {
        let white = UIColor.white.cgColor
        let alpha = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 0.32).cgColor
        let width = bounds.width
        let height = bounds.height
        
        let gradient = CAGradientLayer()
        gradient.colors = [alpha, white, alpha]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.4)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.6)
        gradient.locations = [0.4, 0.5, 0.6]
        gradient.frame = CGRect(x: -width, y: 0, width: width*3, height: height)
        gradient.zPosition = -1
        layer.mask = gradient
        
        let animation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.locations))
        animation.fromValue = [0.0, 0.1, 0.2]
        animation.toValue = [0.8, 0.9, 1.0]
        animation.duration = 1.40
        animation.repeatCount = .infinity
        gradient.add(animation, forKey: shimmerAnimationKey)
    }
    
    private func stopShimmering() {
        layer.mask = nil
    }
}
