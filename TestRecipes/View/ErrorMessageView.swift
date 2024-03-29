//
//  EmptyMessageView.swift
//  TestRecipes
//
//  Created by Tymofii Hazhyi on 6/28/19.
//  Copyright © 2019 Tymofii Hazhyi. All rights reserved.
//

import UIKit

class ErrorMessageView: UIView {
    @IBOutlet private(set) weak var textLabel: UILabel!
    @IBOutlet private(set) weak var contentView: UIView!
    @IBOutlet private(set) weak var reloadBtn: UIButton!
    static let viewTag = 8090
    var tapClosure: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    @IBAction func reloadBtnTapped(_ sender: Any) {
        tapClosure?()
    }
}

extension ErrorMessageView {
    func commonInit() {
        Bundle.main.loadNibNamed(NibName.emptyView.rawValue, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tag = ErrorMessageView.viewTag
    }
}
