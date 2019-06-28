//
//  UICollectionView + emptyMessage.swift
//  TestRecipes
//
//  Created by Tymofii Hazhyi on 6/27/19.
//  Copyright © 2019 Tymofii Hazhyi. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    func setEmptyView(_ message: String, action: (() -> ())?) {
        let empty = EmptyMessageView()
        empty.textLabel.text = message
        empty.tapClosure = action
        empty.reloadBtn.isHidden = action == nil
        
        self.backgroundView = empty
    }
    
    func restore() {
        self.backgroundView = nil
    }
}
