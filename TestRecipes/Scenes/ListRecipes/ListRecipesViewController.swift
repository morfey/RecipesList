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
        buildSearchBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkService?.getRecipesList { [weak self] response, error in
            store.items = response ?? []

            mainQueue {
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
}

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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        push(.details {
            $0.recipe = store.items[safe: indexPath.item]
        })
    }
}

extension ListRecipesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: 250)
    }
}

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

