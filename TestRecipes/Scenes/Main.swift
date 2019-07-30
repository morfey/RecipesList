//
//  Main.swift
//  TestRecipes
//
//  Created by Tymofii Hazhyi on 6/25/19.
//  Copyright © 2019 Tymofii Hazhyi. All rights reserved.
//

import Foundation
import UIKit

final class Main {
    func startProgram() {
        loadWindow()
        let container = DependencyContainer()
        let listViewController = container.makeListRecipesViewController()
        let navigationController = UINavigationController(rootViewController: listViewController)
        appDelegate.window?.rootViewController = navigationController
    }
    
    private func loadWindow() {
        let window = UIWindow.init(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
        window.rootViewController = storyboard.instantiateInitialViewController()
        appDelegate.window = window
        window.makeKeyAndVisible()
    }
}
