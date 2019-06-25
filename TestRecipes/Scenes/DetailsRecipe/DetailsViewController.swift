//
//  DetailsViewController.swift
//  TestRecipes
//
//  Created by Tymofii Hazhyi on 6/25/19.
//  Copyright © 2019 Tymofii Hazhyi. All rights reserved.
//

import UIKit

final class DetailsConfiguration: ConfigurationController {
    var recipe: Recipe?
}

final class DetailsViewController: UIViewController, Configurable {
    var recipe: Recipe?
    
    static func makeFromStoryboard(_ configuration: DetailsConfiguration) -> DetailsViewController {
        let vc = UIStoryboard(name: .details).instantiateVC() as! DetailsViewController
        vc.recipe = configuration.recipe
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
