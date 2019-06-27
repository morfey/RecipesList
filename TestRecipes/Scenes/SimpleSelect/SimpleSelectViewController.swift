//
//  SimpleSelectViewController.swift
//  TestRecipes
//
//  Created by Tymofii Hazhyi on 6/26/19.
//  Copyright © 2019 Tymofii Hazhyi. All rights reserved.
//

import UIKit

final class SimpleSelectConfiguration: ConfigurationClass {
    var cells: [String]?
    var selectedCell: Int?
    var closureDidSelectCell: ((Int) -> Void)?
}

final class SimpleSelectViewController: UIViewController, Configurable {
    @IBOutlet weak var tableView: UITableView!
    fileprivate var selectedCell: Int?
    fileprivate var closureDidSelectCell: ((Int) -> Void)?
    fileprivate var closureCancelWithoutSelect: (() -> Void)?
    fileprivate var cells: [String] = [] {
        didSet {
            tableView?.reloadData()
        }
    }
    
    static func makeFromStoryboard(_ configuration: SimpleSelectConfiguration) -> SimpleSelectViewController {
        let vc = SimpleSelectViewController(nibName: "SimpleSelectViewController", bundle: nil)
        vc.cells = configuration.cells ?? []
        vc.selectedCell = configuration.selectedCell
        vc.closureDidSelectCell = configuration.closureDidSelectCell
        return vc
    }
    
    override func loadView() {
        super.loadView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(hide))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func didSelectRow(_ row: Int) {
        closureDidSelectCell?(row)
        hide()
    }
    
    @objc func hide() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}

extension SimpleSelectViewController: UITableViewDelegate, UITableViewDataSource {
    final func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    final func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    final func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "cell"
        let cell: UITableViewCell
        
        if let cel = tableView.dequeueReusableCell(withIdentifier: identifier) {
            cell = cel
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
        }
        
        cell.textLabel?.text = cells[indexPath.row]
        
        if indexPath.row == selectedCell {
            cell.accessoryType = .checkmark
            cell.textLabel?.textColor = .blue
        } else {
            cell.accessoryType = .none
            cell.textLabel?.textColor = .darkText
        }
        
        return cell
    }
    
    final func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCell = indexPath.row
        didSelectRow(indexPath.row)
        tableView.reloadData()
    }
}