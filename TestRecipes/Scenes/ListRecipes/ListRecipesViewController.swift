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
    
    override func loadView() {
        super.loadView()
        networkService = NetworkService()
        recipesCollectionView.register(UINib(nibName: "RecipeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")

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
}

extension ListRecipesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 300)
    }
}

