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
    case details(DetailsViewController.Configuration.ConfigurationClosure)
    
    var vc: UIViewController {
        switch self {
        case .list:
            return UIStoryboard(name: .list).instantiateVC()
        case .details(let config):
            return DetailsViewController.makeFromStoryboard( DetailsViewController.Configuration(configurationClosure: config))
        }
    }
}

