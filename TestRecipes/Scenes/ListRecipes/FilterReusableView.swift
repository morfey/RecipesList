//
//  FilterReusableView.swift
//  TestRecipes
//
//  Created by Tymofii Hazhyi on 6/26/19.
//  Copyright © 2019 Tymofii Hazhyi. All rights reserved.
//

import UIKit

protocol FilterViewDelegate: class {
    func showComplexityFilter()
    func showCookingTimeFilter()
}

class FilterReusableView: UICollectionReusableView {
    weak var delegate: FilterViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func cookingTimeBtnTapped(_ sender: Any) {
        delegate?.showCookingTimeFilter()
    }
    
    @IBAction func complexityBtnTapped(_ sender: Any) {
        delegate?.showComplexityFilter()
    }
}
