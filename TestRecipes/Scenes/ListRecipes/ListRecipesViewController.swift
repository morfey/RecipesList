//
//  ViewController.swift
//  TestRecipes
//
//  Created by Tymofii Hazhyi on 6/25/19.
//  Copyright © 2019 Tymofii Hazhyi. All rights reserved.
//

import UIKit

class ListRecipesViewController: UIViewController {
    typealias Factory = ViewControllerFactory & RecipeManagerFactory
    
    @IBOutlet private weak var recipesCollectionView: UICollectionView!
    fileprivate var collectionViewHeader: FilterReusableView?
    fileprivate var updateRefreshControl: UIRefreshControl!
    fileprivate var searchController: UISearchController?
    fileprivate var cellIdentifier = "cell"
    fileprivate var headerIdentifier = "header"
    
    private(set) var factory: Factory
    private lazy var recipeManager = factory.makeRecipeManager()
    
    fileprivate var collectionViewNumberOfRows: CGFloat {
        return UIApplication.shared.statusBarOrientation.isPortrait ? 2 : 3
    }
    
    init(factory: Factory) {
        self.factory = factory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate lazy var tapClosure: (() -> ())? = { [weak self] in
        self?.view.showLoader()
        self?.loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.showLoader()
        
        buildSearchBar()
        buildCollectionView()
        
        loadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        recipesCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    fileprivate func loadData() {
        recipeManager.getRecipesList { [weak self] response in
            guard let `self` = self else { return }
            
            mainQueue { [weak self] in
                self?.view.removeLoader()
                self?.updateRefreshControl?.endRefreshing()
            }
            
            switch response {
            case .success(let value):
                self.recipeManager.items = value
                mainQueue { [weak self] in
                    self?.view.removeErrorView()
                    self?.recipesCollectionView.reloadData()
                }
            case .failure(let error):
                self.recipeManager.items = []
                self.handle(error)
            }
        }
    }
    
    fileprivate func handle(_ error: Error) {
        mainQueue { [weak self] in
            guard let `self` = self else { return }
            if self.recipeManager.items.isEmpty == true {
                self.view.showErrorView(error.localizedDescription, action: self.tapClosure)
            } else {
                self.view.removeErrorView()
                self.recipesCollectionView.reloadData()
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
        if recipeManager.items.isEmpty {
            collectionView.setEmptyMessage("No Results")
        } else {
            collectionView.restore()
        }
        return recipeManager.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier,
                                                            for: indexPath) as? RecipeCollectionViewCell,
            let item = recipeManager.items[safe: indexPath.item]
        else {
            return UICollectionViewCell()
        }
        
        cell.configureCell(item: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = recipeManager.items[safe: indexPath.item] {
            let vc = factory.makeDetailsRecipeViewController(recipe: item)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier, for: indexPath)
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
            return CGSize(width: cellWidth, height: cellWidth + 60)
        }
        return CGSize(width: 150, height: 190)
    }
}

// MARK: - FilterViewDelegate
extension ListRecipesViewController: FilterViewDelegate {
    func showComplexityFilter() {
        let complexity = Complexity.allCases
        let complexityClosure: ((Int) -> ())? = { [weak self] index in
            guard let `self` = self else { return }
            self.recipeManager.complexityFilter = complexity[index]
            self.recipeManager.filter(with: self.searchController?.searchBar.text)
            self.setComplexityBtnTiile()
            self.recipesCollectionView.reloadData()
        }
        
        let selecteddIndex = complexity.firstIndex(of: recipeManager.complexityFilter)
        let vc = factory.makeSimpleSecetionViewController(cells: complexity.map { $0.rawValue.capitalized },
                                                          selectClosure: complexityClosure,
                                                          selectedIndex: selecteddIndex)
        present(vc, animated: true, completion: nil)
    }
    
    func showCookingTimeFilter() {
        let cookingTime = CookingTime.allCases
        let cookingClosure: ((Int) -> ())? = { [weak self] index in
            guard let `self` = self else { return }
            self.recipeManager.cookingTime = cookingTime[index]
            self.recipeManager.filter(with: self.searchController?.searchBar.text)
            self.setCookingTimeBtnTitle()
            self.recipesCollectionView.reloadData()
        }
        
        let selectedIndex = cookingTime.firstIndex(of: recipeManager.cookingTime)
        let vc = factory.makeSimpleSecetionViewController(cells: cookingTime.map { $0.title },
                                                          selectClosure: cookingClosure,
                                                          selectedIndex: selectedIndex)
        present(vc, animated: true, completion: nil)
    }
    
    fileprivate func setComplexityBtnTiile() {
        let str = recipeManager.complexityFilter == .any ? "Complexity" : recipeManager.complexityFilter.rawValue.capitalized
        collectionViewHeader?.complexityBtn?.setTitle(str + " ▼", for: .normal)
    }
    
    fileprivate func setCookingTimeBtnTitle() {
        let str = recipeManager.cookingTime == .any ? "Cooking Time" : recipeManager.cookingTime.title
        collectionViewHeader?.cookingTimeBtn?.setTitle(str + " ▼", for: .normal)
    }
}

// MARK: - UISearchControllerDelegate & UISearchResultsUpdating
extension ListRecipesViewController: UISearchControllerDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        recipeManager.filter(with: searchController.searchBar.text)
        recipesCollectionView.reloadData()
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        recipeManager.filter(with: nil)
        recipesCollectionView.reloadData()
    }
}

// MARK: - Setup View
extension ListRecipesViewController {
    fileprivate func buildCollectionView() {
        recipesCollectionView.register(UINib(nibName: NibName.recipeCell.rawValue, bundle: nil),
                                       forCellWithReuseIdentifier: cellIdentifier)
        recipesCollectionView.register(UINib(nibName: NibName.filterView.rawValue, bundle: nil),
                                       forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                       withReuseIdentifier: headerIdentifier)
        
        updateRefreshControl = UIRefreshControl()
        updateRefreshControl.addTarget(self, action: #selector(refreshControlHandler), for: .valueChanged)
        recipesCollectionView.addSubview(updateRefreshControl)
    }
    
    fileprivate func buildSearchBar() {
        definesPresentationContext = true
        searchController = UISearchController(searchResultsController: nil)
        searchController?.delegate = self
        searchController?.searchResultsUpdater = self
        searchController?.dimsBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

