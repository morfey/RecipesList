//
//  Configurable.swift
//  TestRecipes
//
//  Created by Tymofii Hazhyi on 6/25/19.
//  Copyright © 2019 Tymofii Hazhyi. All rights reserved.
//

import Foundation
import UIKit

protocol Configurable: class {
    associatedtype Configuration: ConfigurationController
    static func makeFromStoryboard(_ configuration: Configuration) -> Self
}

protocol ConfigurationController {
    typealias ConfigurationClosure = (Self) -> ()
    init()
    init(configurationClosure: ConfigurationClosure)
}

extension ConfigurationController {
    init(configurationClosure: ConfigurationClosure) {
        self.init()
        configurationClosure(self)
    }
}
