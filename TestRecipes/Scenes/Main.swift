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
    func startProgram(_ vc: ViewControllers? = nil) {
        loadWindow()
        if let vc = vc {
            appDelegate.window?.rootViewController = vc.vc
        } else {
            appDelegate.window?.rootViewController = ViewControllers.list.vc
        }
    }
    
    private func loadWindow() {
        let window = UIWindow.init(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
        window.rootViewController = storyboard.instantiateViewController(withIdentifier: "LaunchScreenController")
        appDelegate.window = window
        window.makeKeyAndVisible()
    }
}
