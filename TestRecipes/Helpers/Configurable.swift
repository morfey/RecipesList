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
    associatedtype Configuration: ConfigurationClass
    static func makeFromStoryboard(_ configuration: Configuration) -> Self
}

protocol ConfigurationClass {
    typealias ConfigurationClosure = (Self) -> ()
    init()
    init(_ configurationClosure: ConfigurationClosure)
}

extension ConfigurationClass {
    init(_ configurationClosure: ConfigurationClosure) {
        self.init()
        configurationClosure(self)
    }
}
