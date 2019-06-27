//
//  ViewController.swift
//  TestRecipes
//
//  Created by Tymofii Hazhyi on 6/25/19.
//  Copyright © 2019 Tymofii Hazhyi. All rights reserved.
//

import UIKit

class ListRecipesViewController: UIViewController {
    @IBOutlet weak var recipesCollectionView: UICollectionView!
    fileprivate var networkService: NetworkService?
    fileprivate var searchController: UISearchController?
    
    override func loadView() {
        super.loadView()
        networkService = NetworkService()
        recipesCollectionView.register(UINib(nibName: "RecipeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        recipesCollectionView.register(UINib(nibName: "FilterReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        buildSearchBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.showLoader()
        networkService?.getRecipesList { [weak self] response, error in
            store.items = response ?? []

            mainQueue {
                self?.view.removeLoader()
                self?.recipesCollectionView.reloadData()
            }
        }
    }
    
    fileprivate func buildSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        searchController?.delegate = self
        searchController?.searchResultsUpdater = self
        searchController?.dimsBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        recipesCollectionView.collectionViewLayout.invalidateLayout()
    }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension ListRecipesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return store.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? RecipeCollectionViewCell,
            let item = store.items[safe: indexPath.item]
        else {
            return UICollectionViewCell()
        }
        
        cell.configureCell(item: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        push(.details {
            $0.recipe = store.items[safe: indexPath.item]
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: indexPath)
        (supplementaryView as? FilterReusableView)?.delegate = self
        return supplementaryView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 45)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ListRecipesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfRows: CGFloat = UIDevice.current.orientation == .portrait ? 2 : 3
        let ascpect: CGFloat = UIDevice.current.orientation == .portrait ? 1.4 : 1.2
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            let spacing = flowLayout.minimumLineSpacing
            let cellWidth = (collectionView.frame.width - (spacing + (flowLayout.sectionInset.left * numberOfRows))) / numberOfRows
            return CGSize(width: cellWidth, height: cellWidth * ascpect)
        }
        return .zero
    }
}

// MARK: - FilterViewDelegate
extension ListRecipesViewController: FilterViewDelegate {
    func showComplexityFilter() {
        let complexity = Complexity.allCases
        let complexityClosure: ((Int) -> ())? = { index in
            store.complexityFilter = complexity[index]
            store.filter(with: nil)
            self.recipesCollectionView.reloadData()
        }
        
        present(ViewControllers.simpleSelect {
            $0.cells = complexity.map { $0.rawValue.capitalized }
            $0.closureDidSelectCell = complexityClosure
            $0.selectedCell = complexity.firstIndex(of: store.complexityFilter)
        }.nav, animated: true, completion: nil)
    }
    
    func showCookingTimeFilter() {
        let cookingTime = CookingTime.allCases
        let cookingClosure: ((Int) -> ())? = { index in
            store.cookingTime = cookingTime[index]
            store.filter(with: nil)
            self.recipesCollectionView.reloadData()
        }
        
        present(ViewControllers.simpleSelect {
            $0.cells = cookingTime.map { $0.title }
            $0.closureDidSelectCell = cookingClosure
            $0.selectedCell = cookingTime.firstIndex(of: store.cookingTime)
        }.nav, animated: true, completion: nil)
    }
}

// MARK: - UISearchControllerDelegate & UISearchResultsUpdating
extension ListRecipesViewController: UISearchControllerDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, !text.isEmpty {
            store.filter(with: text)
        } else {
            store.filter(with: nil)
        }
        recipesCollectionView.reloadData()
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        store.filter(with: nil)
        recipesCollectionView.reloadData()
    }
}

