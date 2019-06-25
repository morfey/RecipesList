//
//  ViewControllers.swift
//  TestRecipes
//
//  Created by Tymofii Hazhyi on 6/25/19.
//  Copyright © 2019 Tymofii Hazhyi. All rights reserved.
//

import Foundation
import UIKit

enum ViewControllers {
    case list
    case details
    
    var vc: UIViewController {
        switch self {
        case .list:
            return UIStoryboard(name: "ListRecipes", bundle: nil).instantiateInitialViewController()!
        default:
            return UIViewController()
        }
    }
}

