//
//  DetailsViewController.swift
//  TestRecipes
//
//  Created by Tymofii Hazhyi on 6/25/19.
//  Copyright © 2019 Tymofii Hazhyi. All rights reserved.
//

import UIKit

final class DetailsConfiguration: ConfigurationClass {
    var recipe: Recipe?
}

extension DetailsViewController {
    enum SectionType {
        case ingridients(String, [CellType])
        case instructions([CellType])
    }
}

final class DetailsViewController: UIViewController, Configurable {
    @IBOutlet weak var tableView: UITableView!
    fileprivate var sections: [SectionType] = []
    
    var recipe: Recipe?
    
    static func makeFromStoryboard(_ configuration: DetailsConfiguration) -> DetailsViewController {
        let vc = UIStoryboard(name: .details).instantiateVC() as! DetailsViewController
        vc.recipe = configuration.recipe
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadSections()
    }
    
    fileprivate func reloadSections() {
        var sections: [SectionType] = []
        
        if let ingridientsSection = makeIngridientsSection() {
            sections.append(ingridientsSection)
        }
        
        if let instructionsSection = makeInstructionsSection() {
            sections.append(instructionsSection)
        }
        
        self.sections = sections
        self.tableView.reloadData()
    }
    
    fileprivate func makeIngridientsSection() -> SectionType? {
        if let ingridientsCount = recipe?.ingredients.count, ingridientsCount != 0 {
            var cells = [CellType]()
            recipe?.ingredients.forEach {
                let vm = BaseTableCellViewModel(text: $0.name, detailText: $0.quantity, numberOfLines: 0)
                cells.append(.baseCell(vm))
            }
            return .ingridients("Ingridients \(ingridientsCount)", cells)
        }
        return nil
    }
    
    fileprivate func makeInstructionsSection() -> SectionType? {
        if recipe?.steps.isEmpty != true {
            var cells = [CellType]()
            recipe?.steps.forEach {
                let vm = BaseTableCellViewModel(text: $0, numberOfLines: 0)
                cells.append(.baseCell(vm))
            }
            return .instructions(cells)
        }
        return nil
    }
}

extension DetailsViewController: UITableViewDelegate, UITableViewDataSource {
    private func rows(inSection section: Int) -> [CellType] {
        switch sections[section] {
        case .ingridients(_, let rows),
             .instructions(let rows):
            return rows
        }
    }
    
    private func rowType(atIndexPath indexPath: IndexPath) -> CellType {
        return rows(inSection: indexPath.section)[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = rowType(atIndexPath: indexPath)
        let factory = TableViewCellHelper.factory(for: type)
        let cell: UITableViewCell?
        
        if let cel = tableView.dequeueReusableCell(withIdentifier: factory.cell().name()) as? TableViewCellProtocol {
            cell = cel as? UITableViewCell
        } else {
            let cell_: TableViewCellProtocol = factory.cell()
            cell = cell_ as? UITableViewCell
        }
        (cell as? TableViewCellProtocol)?.configureCell(vm: factory.vm)
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch sections[section] {
        case .ingridients(let str, _):
            return str
        case .instructions(_):
            return "Instructions"
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows(inSection: section).count
    }
}

