//
//  DetailsViewController.swift
//  TestRecipes
//
//  Created by Tymofii Hazhyi on 6/25/19.
//  Copyright © 2019 Tymofii Hazhyi. All rights reserved.
//

import UIKit

final class DetailsViewController: UIViewController, Configurable {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!
    fileprivate var sections: [SectionType] = []
    fileprivate var recipe: Recipe?
    fileprivate var headerHeight: CGFloat {
        return view.frame.width * (UIApplication.shared.statusBarOrientation.isPortrait ? 0.5 : 0.3)
    }
    
    static func makeFromStoryboard(_ configuration: DetailsConfiguration) -> DetailsViewController {
        let vc = UIStoryboard(name: .details).instantiateVC() as! DetailsViewController
        vc.recipe = configuration.recipe
        return vc
    }
    
    override func loadView() {
        super.loadView()
        imageViewHeightConst.constant = headerHeight
        tableView.contentInset = UIEdgeInsets(top: headerHeight, left: 0, bottom: 0, right: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadSections()
        imageView.kf.setImage(with: URL(string: recipe?.imageURL ?? ""), placeholder: #imageLiteral(resourceName: "placeholder"))
    }
    
    fileprivate func reloadSections() {
        var sections: [SectionType] = []
        
        if let titleSection = makeTitleSection() {
            sections.append(titleSection)
        }
        
        if let ingridientsSection = makeIngridientsSection() {
            sections.append(ingridientsSection)
        }
        
        if let instructionsSection = makeInstructionsSection() {
            sections.append(instructionsSection)
        }
        
        self.sections = sections
        self.tableView.reloadData()
    }
    
    fileprivate func makeTitleSection()  -> SectionType? {
        if let name = recipe?.name {
            let vm = BaseTableCellViewModel(text: name,
                                            numberOfLines: 0,
                                            textAligment: .center)
            return .title([.baseCell(vm)])
        }
        return nil
    }
    
    fileprivate func makeIngridientsSection() -> SectionType? {
        if let ingridientsCount = recipe?.ingredients.count, ingridientsCount != 0 {
            var cells = [CellType]()
            recipe?.ingredients.forEach {
                let vm = BaseTableCellViewModel(text: $0.name,
                                                detailText: $0.quantity,
                                                numberOfLines: 0)
                cells.append(.detailsCell(vm))
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

// MARK: - UITableViewDelegate & UITableViewDataSource
extension DetailsViewController: UITableViewDelegate, UITableViewDataSource {
    private func rows(inSection section: Int) -> [CellType] {
        switch sections[section] {
        case .ingridients(_, let rows),
             .title(let rows),
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
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch sections[section] {
        case .ingridients,
             .instructions:
            return tableView.sectionHeaderHeight
        case .title:
            return CGFloat.leastNonzeroMagnitude
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows(inSection: section).count
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = headerHeight - (scrollView.contentOffset.y + headerHeight)
        let height = min(max(y, 0), view.bounds.size.height)
        imageViewHeightConst.constant = height
    }
}

