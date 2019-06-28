//
//  String + capitalized.swift
//  TestRecipes
//
//  Created by Tymofii Hazhyi on 6/28/19.
//  Copyright © 2019 Tymofii Hazhyi. All rights reserved.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
}
