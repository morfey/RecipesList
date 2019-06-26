//
//  BasicTVCell.swift
//  TestRecipes
//
//  Created by Tymofii Hazhyi on 6/26/19.
//  Copyright © 2019 Tymofii Hazhyi. All rights reserved.
//

import Foundation
import UIKit

class BasicTableCell: UITableViewCell, TableViewCellProtocol {
    fileprivate weak var viewModel: BaseTableCellViewModel? { didSet { updateViews() } }
    
    required override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func name() -> String {
        return "BasicTableCell"
    }
    
    static func make() -> TableViewCellProtocol {
        return BasicTableCell(style: .default, reuseIdentifier: String(describing: self))
    }
    
    static func makeValue1() -> TableViewCellProtocol {
        return BasicTableCell(style: .value1, reuseIdentifier: String(describing: self))
    }
    
    func configureCell(vm: Any?) {
        if let vm = vm as? BaseTableCellViewModel {
            configure(viewModel: vm)
        }
    }
    
    func configure(viewModel: BaseTableCellViewModel) {
        self.viewModel = viewModel
    }
    
    fileprivate func updateViews() {
        guard let viewModel      = viewModel else { return }
        detailTextLabel?.text    = viewModel.detailText
        textLabel?.text          = viewModel.text
        textLabel?.numberOfLines = viewModel.numberOfLines
        textLabel?.textAlignment = viewModel.textAligment
    }
}
