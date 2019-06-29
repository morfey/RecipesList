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
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(origin: .zero, size: bounds.size))
        messageLabel.text = message
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
    }
    
    func restore() {
        self.backgroundView = nil
    }
}
