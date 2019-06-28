//
//  ViewController.swift
//  TestRecipes
//
//  Created by Tymofii Hazhyi on 6/25/19.
//  Copyright © 2019 Tymofii Hazhyi. All rights reserved.
//

import UIKit

class ListRecipesViewController: UIViewController {
    @IBOutlet private(set) weak var recipesCollectionView: UICollectionView!
    fileprivate var collectionViewHeader: FilterReusableView?
    fileprivate var updateRefreshControl: UIRefreshControl!
    fileprivate var searchController: UISearchController?
    fileprivate var networkService = NetworkService()
    fileprivate var dataStore = DataStore()
    
    fileprivate var collectionViewNumberOfRows: CGFloat {
        return UIApplication.shared.statusBarOrientation.isPortrait ? 2 : 3
    }
    
    fileprivate var cellAspectRatio: CGFloat {
        return UIApplication.shared.statusBarOrientation.isPortrait ? 1.35 : 1.25
    }
    
    override func loadView() {
        super.loadView()
        definesPresentationContext = true
        buildSearchBar()
        
        recipesCollectionView.register(UINib(nibName: "RecipeCollectionViewCell", bundle: nil),
                                       forCellWithReuseIdentifier: "cell")
        recipesCollectionView.register(UINib(nibName: "FilterReusableView", bundle: nil),
                                       forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                       withReuseIdentifier: "header")
        
        updateRefreshControl = UIRefreshControl()
        updateRefreshControl.addTarget(self, action: #selector(refreshControlHandler), for: .valueChanged)
        recipesCollectionView.addSubview(updateRefreshControl)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.showLoader()
        loadData()
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
    
    fileprivate func loadData() {
        networkService.getRecipesList { [weak self] response, error in
            let tapClosure: (() -> ())? = { [weak self] in
                self?.view.showLoader()
                self?.loadData()
            }
            
            if let error = error {
                mainQueue { [weak self] in
                    self?.view.removeLoader()
                    self?.collectionViewHeader?.isHidden = true
                    self?.recipesCollectionView.setEmptyView(error, action: tapClosure)
                }
            } else {
                self?.dataStore.items = response ?? []
                
                mainQueue { [weak self] in
                    self?.view.removeLoader()
                    self?.collectionViewHeader?.isHidden = false
                    self?.recipesCollectionView.restore()
                    self?.recipesCollectionView.reloadData()
                    self?.updateRefreshControl?.endRefreshing()
                }
            }
        }
    }
    
    @objc fileprivate func refreshControlHandler() {
        loadData()
    }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension ListRecipesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if dataStore.items.count == 0 {
            collectionView.setEmptyView("No Results", action: nil)
        } else {
            collectionView.restore()
        }
        return dataStore.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
                                                            for: indexPath) as? RecipeCollectionViewCell,
            let item = dataStore.items[safe: indexPath.item]
        else {
            return UICollectionViewCell()
        }
        
        cell.configureCell(item: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        push(.details { [weak self] in
            $0.recipe = self?.dataStore.items[safe: indexPath.item]
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: indexPath)
        let filterView = supplementaryView as? FilterReusableView
        collectionViewHeader = filterView
        filterView?.delegate = self
        return supplementaryView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 45)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ListRecipesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            let spacing = flowLayout.minimumInteritemSpacing
            let cellWidth = (collectionView.frame.width - (spacing + (flowLayout.sectionInset.left * collectionViewNumberOfRows))) / collectionViewNumberOfRows
            return CGSize(width: cellWidth, height: cellWidth * cellAspectRatio)
        }
        return CGSize(width: 150, height: 190)
    }
}

// MARK: - FilterViewDelegate
extension ListRecipesViewController: FilterViewDelegate {
    func showComplexityFilter() {
        let complexity = Complexity.allCases
        let complexityClosure: ((Int) -> ())? = { [weak self] index in
            self?.dataStore.complexityFilter = complexity[index]
            self?.dataStore.filter(with: self?.searchController?.searchBar.text)
            self?.setComplexityBtnTiile()
            self?.recipesCollectionView.reloadData()
        }
        
        present(ViewControllers.simpleSelect { [weak self] in
            $0.cells = complexity.map { $0.rawValue.capitalized }
            $0.closureDidSelectCell = complexityClosure
            $0.selectedCell = complexity.firstIndex(of: self?.dataStore.complexityFilter ?? .any)
        }.nav, animated: true, completion: nil)
    }
    
    func showCookingTimeFilter() {
        let cookingTime = CookingTime.allCases
        let cookingClosure: ((Int) -> ())? = { [weak self] index in
            self?.dataStore.cookingTime = cookingTime[index]
            self?.dataStore.filter(with: self?.searchController?.searchBar.text)
            self?.setCookingTimeBtnTitle()
            self?.recipesCollectionView.reloadData()
        }
        
        present(ViewControllers.simpleSelect { [weak self] in
            $0.cells = cookingTime.map { $0.title }
            $0.closureDidSelectCell = cookingClosure
            $0.selectedCell = cookingTime.firstIndex(of: self?.dataStore.cookingTime ?? .any)
        }.nav, animated: true, completion: nil)
    }
    
    fileprivate func setComplexityBtnTiile() {
        var str = ""
        switch dataStore.complexityFilter {
        case .any:
            str = "Complexity"
        default:
            str = dataStore.complexityFilter.rawValue.capitalized
        }
        collectionViewHeader?.complexityBtn?.setTitle(str + " ▼", for: .normal)
    }
    
    fileprivate func setCookingTimeBtnTitle() {
        var str = ""
        switch dataStore.cookingTime {
        case .any:
            str = "Cooking Time"
        default:
            str = dataStore.cookingTime.title
        }
        collectionViewHeader?.cookingTimeBtn?.setTitle(str + " ▼", for: .normal)
    }
}

// MARK: - UISearchControllerDelegate & UISearchResultsUpdating
extension ListRecipesViewController: UISearchControllerDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        dataStore.filter(with: searchController.searchBar.text)
        recipesCollectionView.reloadData()
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        dataStore.filter(with: nil)
        recipesCollectionView.reloadData()
    }
}

