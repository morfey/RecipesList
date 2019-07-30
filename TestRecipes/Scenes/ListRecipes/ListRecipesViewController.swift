//
//  ViewController.swift
//  TestRecipes
//
//  Created by Tymofii Hazhyi on 6/25/19.
//  Copyright © 2019 Tymofii Hazhyi. All rights reserved.
//

import UIKit

class ListRecipesViewController: UIViewController {
    typealias Factory = ViewControllerFactory & NetworkServiceFactory & DataSouceFactory
    
    @IBOutlet private weak var recipesCollectionView: UICollectionView!
    fileprivate var collectionViewHeader: FilterReusableView?
    fileprivate var updateRefreshControl: UIRefreshControl!
    fileprivate var searchController: UISearchController?
    fileprivate var cellIdentifier = "cell"
    fileprivate var headerIdentifier = "header"
    
    private(set) var factory: Factory
    private lazy var networkService = factory.makeNetworkService()
    private lazy var dataStore = factory.makeDataSource()
    
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
        networkService.getRecipesList { [weak self] response, error in
            self?.dataStore.items = response ?? []
            
            mainQueue { [weak self] in
                self?.view.removeLoader()
                self?.updateRefreshControl?.endRefreshing()
            }
            
            if let error = error, self?.dataStore.items.isEmpty == true {
                mainQueue { [weak self] in
                    self?.view.showErrorView(error, action: self?.tapClosure)
                }
            } else {
                mainQueue { [weak self] in
                    self?.view.removeErrorView()
                    self?.recipesCollectionView.reloadData()
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
        if dataStore.items.isEmpty {
            collectionView.setEmptyMessage("No Results")
        } else {
            collectionView.restore()
        }
        return dataStore.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier,
                                                            for: indexPath) as? RecipeCollectionViewCell,
            let item = dataStore.items[safe: indexPath.item]
        else {
            return UICollectionViewCell()
        }
        
        cell.configureCell(item: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = dataStore.items[safe: indexPath.item] {
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
            self?.dataStore.complexityFilter = complexity[index]
            self?.dataStore.filter(with: self?.searchController?.searchBar.text)
            self?.setComplexityBtnTiile()
            self?.recipesCollectionView.reloadData()
        }
        
        let conf = SimpleSelectConfiguration()
        conf.cells = complexity.map { $0.rawValue.capitalized }
        conf.closureDidSelectCell = complexityClosure
        conf.selectedCell = complexity.firstIndex(of: dataStore.complexityFilter)
        let vc = factory.makeSimpleSelectViewController(configuration: conf)
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
    
    func showCookingTimeFilter() {
        let cookingTime = CookingTime.allCases
        let cookingClosure: ((Int) -> ())? = { [weak self] index in
            self?.dataStore.cookingTime = cookingTime[index]
            self?.dataStore.filter(with: self?.searchController?.searchBar.text)
            self?.setCookingTimeBtnTitle()
            self?.recipesCollectionView.reloadData()
        }
        
        let conf = SimpleSelectConfiguration()
        conf.cells = cookingTime.map { $0.title }
        conf.closureDidSelectCell = cookingClosure
        conf.selectedCell = cookingTime.firstIndex(of: dataStore.cookingTime)
        let vc = factory.makeSimpleSelectViewController(configuration: conf)
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
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

