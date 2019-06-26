//
//  TableViewCellProtocol.swift
//  TestRecipes
//
//  Created by Tymofii Hazhyi on 6/26/19.
//  Copyright © 2019 Tymofii Hazhyi. All rights reserved.
//

import Foundation

protocol TableViewCellProtocol {
    static func make() -> TableViewCellProtocol
    func name() -> String
    func configureCell(vm: Any?)
}

typealias TableViewCellFactory = () -> TableViewCellProtocol

enum CellType {
    case
    baseCell(BaseTableCellViewModel)
}

enum TableViewCellHelper {
    static func factory(for type: CellType?) -> (cell: TableViewCellFactory, vm: Any?) {
        switch type {
        case .baseCell(let vm)?:
            return (BasicTableCell.make, vm)
        case .none:
            return (BasicTableCell.make, nil)
        }
    }
}
