//
//  SimpleSelectViewController.swift
//  TestRecipes
//
//  Created by Tymofii Hazhyi on 6/26/19.
//  Copyright © 2019 Tymofii Hazhyi. All rights reserved.
//

import UIKit

final class SimpleSelectViewController: UIViewController {
    @IBOutlet private(set) weak var tableView: UITableView!
    private(set) var selectedCell: Int?
    private(set) var closureDidSelectCell: ((Int) -> ())?
    private(set) var cells = [String]()
    
    init(configuration: SimpleSelectConfiguration) {
        closureDidSelectCell = configuration.closureDidSelectCell
        selectedCell = configuration.selectedCell
        cells = configuration.cells ?? []
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(hide))
    }

    fileprivate func didSelectRow(_ row: Int) {
        closureDidSelectCell?(row)
        hide()
    }
    
    @objc fileprivate func hide() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}

extension SimpleSelectViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
            cell.textLabel?.textColor = cell.tintColor
        } else {
            cell.accessoryType = .none
            cell.textLabel?.textColor = .darkText
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCell = indexPath.row
        didSelectRow(indexPath.row)
        tableView.reloadData()
    }
}
