//
//  DetailsViewController.swift
//  TestRecipes
//
//  Created by Tymofii Hazhyi on 6/25/19.
//  Copyright © 2019 Tymofii Hazhyi. All rights reserved.
//

import UIKit

final class DetailsViewController: UIViewController {
    @IBOutlet private(set) weak var tableView: UITableView!
    @IBOutlet private weak var imageViewHeightConst: NSLayoutConstraint!
    @IBOutlet private weak var imageView: UIImageView!
    private(set) var sections: [SectionType] = []
    private(set) var recipe: Recipe?
    fileprivate var headerHeight: CGFloat {
        return view.frame.width * (UIApplication.shared.statusBarOrientation.isPortrait ? 0.5 : 0.3)
    }
    
    init(recipe: Recipe) {
        self.recipe = recipe
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadSections()
        imageViewHeightConst.constant = headerHeight
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
        
        tableView.contentInset = UIEdgeInsets(top: headerHeight, left: 0, bottom: 0, right: 0)
        tableView.reloadData()
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
                let vm = BaseTableCellViewModel(text: $0.name.trimmingCharacters(in: .whitespaces).capitalizingFirstLetter(),
                                                detailText: $0.quantity,
                                                numberOfLines: 0)
                cells.append(.detailsCell(vm))
            }
            return .ingridients(Strings.ingridients.rawValue + " \(ingridientsCount)", cells)
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
        
        if let reusableCell = tableView.dequeueReusableCell(withIdentifier: factory.cell().name()) {
            cell = reusableCell
        } else {
            cell = factory.cell() as? UITableViewCell
        }
        (cell as? TableViewCellProtocol)?.configureCell(vm: factory.vm)
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch sections[section] {
        case .ingridients(let str, _):
            return str
        case .instructions(_):
            return Strings.instructions.rawValue
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

