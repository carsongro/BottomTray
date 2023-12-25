//
//  Extensions.swift
//  BottomTray
//
//  Created by Carson Gross on 12/24/23.
//

import Foundation
import UIKit

extension UIButton {
    func grabberBlur(
        style: UIBlurEffect.Style = .systemThinMaterial,
        cornerRadius: CGFloat = 0.0
    ) {
        backgroundColor = .clear
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: style))
        blurView.isUserInteractionEnabled = false
        blurView.backgroundColor = .clear
        if cornerRadius > 0 {
            blurView.layer.cornerRadius = cornerRadius
            blurView.layer.masksToBounds = true
        }
        insertSubview(blurView, at: 0)
        
        blurView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: blurView.topAnchor, constant: -19.5),
            leftAnchor.constraint(equalTo: blurView.leftAnchor, constant: -3.5),
            rightAnchor.constraint(equalTo: blurView.rightAnchor, constant: 3.5),
            bottomAnchor.constraint(equalTo: blurView.bottomAnchor, constant: 19.5),
        ])
        
        if let imageView {
            imageView.backgroundColor = .clear
            bringSubviewToFront(imageView)
        }
    }
}
