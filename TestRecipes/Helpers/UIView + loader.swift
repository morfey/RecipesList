//
//  UIView + loader.swift
//  TestRecipes
//
//  Created by Tymofii Hazhyi on 6/27/19.
//  Copyright © 2019 Tymofii Hazhyi. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    private static let loaderTag = 9999
    
    private var loaderView: UIView? {
        return viewWithTag(UIView.loaderTag)
    }
    
    func showLoader() {
        addLoaderView(opacity: 0.25)
    }
    
    private func addLoaderView(opacity: Float = 0) {
        loaderView?.removeFromSuperview()
        
        let container = UIView()
        container.tag = UIView.loaderTag
        isUserInteractionEnabled = false
        
        if opacity != 0 {
            let blurEffect = UIBlurEffect(style: .prominent)
            let blurView = UIVisualEffectView(effect: blurEffect)
            blurView.layer.opacity = opacity
            container.addSubViewOnEntireSize(contentView: blurView)
        }
        
        let animationView = UIActivityIndicatorView(style: .gray)
        
        container.addSubViewOnEntireSize(contentView: animationView)
        addSubViewOnEntireSize(contentView: container)
        bringSubviewToFront(container)
        
        animationView.startAnimating()
    }
    
    func removeLoader() {
        isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.3, animations: {
            self.loaderView?.alpha = 0
        }, completion: { _ in
            self.loaderView?.removeFromSuperview()
        })
    }
    
    public func addSubViewOnEntireSize(contentView: UIView) {
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        contentView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        contentView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        setNeedsLayout()
    }
}
