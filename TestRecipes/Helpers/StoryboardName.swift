//
//  StoryboardName.swift
//  TestRecipes
//
//  Created by Tymofii Hazhyi on 6/25/19.
//  Copyright © 2019 Tymofii Hazhyi. All rights reserved.
//

import Foundation
import UIKit

enum StoryboardName: String {
    case list    = "ListRecipes"
    case details = "DetailsRecipe"
}

extension UIStoryboard {
    convenience init(name: StoryboardName) {
        self.init(name: name.rawValue, bundle: nil)
    }
    
    func instantiateVC<T: UIViewController>(withIdentifier identifier: String = String(describing: T.self)) -> T {
        return self.instantiateInitialViewController() as! T
    }
}
