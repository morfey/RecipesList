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
        errorView.frame = bounds
        bringSubviewToFront(errorView)
    }
    
    func removeErrorView() {
        viewWithTag(ErrorMessageView.viewTag)?.removeFromSuperview()
    }
}
