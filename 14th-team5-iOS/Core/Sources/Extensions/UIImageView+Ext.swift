//
//  UIImageView+Ext.swift
//  Core
//
//  Created by 마경미 on 12.01.24.
//

import UIKit

extension UIImageView {
    public func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
