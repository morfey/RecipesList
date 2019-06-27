//
//  SimpleSelectConfiguration.swift
//  TestRecipes
//
//  Created by Tymofii Hazhyi on 6/27/19.
//  Copyright © 2019 Tymofii Hazhyi. All rights reserved.
//

import Foundation

final class SimpleSelectConfiguration: ConfigurationClass {
    var cells: [String]?
    var selectedCell: Int?
    var closureDidSelectCell: ((Int) -> ())?
}
