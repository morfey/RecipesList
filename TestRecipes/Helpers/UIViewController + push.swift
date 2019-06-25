//
//  UIViewController.swift
//  TestRecipes
//
//  Created by Tymofii Hazhyi on 6/25/19.
//  Copyright © 2019 Tymofii Hazhyi. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func push(_ vc: ViewControllers, animated: Bool = true) {
        guard let nav = navigationController else {
            (self as? UINavigationController)?.pushViewController(vc: vc, animated: animated)
            return
        }
        nav.pushViewController(vc: vc, animated: animated)
    }
    
    func push(vc: ViewControllers, animated: Bool = true) {
        push(vc, animated: animated)
    }
}

extension UINavigationController {
    func pushViewController(vc: ViewControllers, animated: Bool = true) {
        pushViewController(vc.vc, animated: animated)
    }
}
