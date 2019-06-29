//
//  UIView + errorView.swift
//  TestRecipes
//
//  Created by Tymofii Hazhyi on 6/29/19.
//  Copyright © 2019 Tymofii Hazhyi. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func showErrorView(_ message: String, action: (() -> ())?) {
        removeErrorView()
        let errorView = ErrorMessageView()
        addSubview(errorView)
        errorView.textLabel.text = message
        errorView.tapClosure = action
        errorView.layer.zPosition = 1
        errorView.frame = bounds
    }
    
    func removeErrorView() {
        viewWithTag(ErrorMessageView.viewTag)?.removeFromSuperview()
    }
}
