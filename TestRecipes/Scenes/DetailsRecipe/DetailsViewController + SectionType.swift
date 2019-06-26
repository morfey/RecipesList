//
//  DetailsViewController + SectionType.swift
//  TestRecipes
//
//  Created by Tymofii Hazhyi on 6/26/19.
//  Copyright © 2019 Tymofii Hazhyi. All rights reserved.
//

import Foundation

extension DetailsViewController {
    enum SectionType {
        case title([CellType])
        case ingridients(String, [CellType])
        case instructions([CellType])
    }
}
