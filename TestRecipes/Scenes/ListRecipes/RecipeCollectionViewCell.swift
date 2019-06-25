//
//  RecipeCollectionViewCell.swift
//  TestRecipes
//
//  Created by Tymofii Hazhyi on 6/25/19.
//  Copyright © 2019 Tymofii Hazhyi. All rights reserved.
//

import UIKit

class RecipeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell(name: String) {
        nameLabel.text = name
    }
}
