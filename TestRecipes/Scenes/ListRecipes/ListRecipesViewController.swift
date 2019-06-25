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
    fileprivate var recipes: [Recipe] = []
    
    override func loadView() {
        super.loadView()
        recipesCollectionView.register(UINib(nibName: "RecipeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkService = NetworkService()
        networkService?.getRecipesList { [weak self] items, error in
            self?.recipes = items ?? []
            DispatchQueue.main.async {
                self?.recipesCollectionView.reloadData()
            }
        }
    }
}

extension ListRecipesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? RecipeCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configureCell(item: recipes[indexPath.item])
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

