//
//  BaseTVCellVM.swift
//  TestRecipes
//
//  Created by Tymofii Hazhyi on 6/26/19.
//  Copyright © 2019 Tymofii Hazhyi. All rights reserved.
//

import Foundation
import UIKit

protocol BaseTableCellViewModelProtocol: class {
    var text: String? { get }
    var detailText: String? { get }
    var numberOfLines: Int { get }
    var textAligment: NSTextAlignment { get }
}

class BaseTableCellViewModel: BaseTableCellViewModelProtocol {
    let text: String?
    let detailText: String?
    let numberOfLines: Int
    let textAligment: NSTextAlignment

    init(text: String?, detailText: String? = nil, numberOfLines: Int = 1, textAligment: NSTextAlignment = .left) {
        self.text           = text
        self.detailText     = detailText
        self.numberOfLines  = numberOfLines
        self.textAligment   = textAligment
    }
}
