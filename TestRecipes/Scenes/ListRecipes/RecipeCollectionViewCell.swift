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
    @IBOutlet private(set) weak var nameLabel: UILabel!
    @IBOutlet private(set) weak var imageView: UIImageView!
    @IBOutlet private(set) weak var ingridientsCountLabel: UILabel!
    @IBOutlet private(set) weak var minutesCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell(item: Recipe) {
        imageView.kf.setImage(with: URL(string: item.imageURL ?? ""), placeholder: #imageLiteral(resourceName: "placeholder"))
        nameLabel.text = item.name
        ingridientsCountLabel.text = "\(item.ingredients.count) " + Strings.ingridients.rawValue.lowercased()
        minutesCountLabel.text = "\(item.timers.reduce(0, +)) " + Strings.minutes.rawValue.lowercased()
    }
}
