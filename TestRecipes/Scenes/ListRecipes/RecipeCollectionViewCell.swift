//
//  RecipeCollectionViewCell.swift
//  TestRecipes
//
//  Created by Tymofii Hazhyi on 6/25/19.
//  Copyright © 2019 Tymofii Hazhyi. All rights reserved.
//

import UIKit
import Kingfisher

class RecipeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ingridientsCountLabel: UILabel!
    @IBOutlet weak var minutesCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell(item: Recipe) {
        imageView.kf.setImage(with: URL(string: item.imageURL ?? ""))
        nameLabel.text = item.name
        ingridientsCountLabel.text = "\(item.ingredients.count) ingridients"
        minutesCountLabel.text = "\(item.timers.reduce(0, +)) minutes"
    }
}
