//
//  GlobalVariables.swift
//  TestRecipes
//
//  Created by Tymofii Hazhyi on 6/25/19.
//  Copyright © 2019 Tymofii Hazhyi. All rights reserved.
//

import Foundation
import UIKit

var application: UIApplication { return UIApplication.shared }
var appDelegate: AppDelegate { return application.delegate as! AppDelegate }
var keyWindow: UIView? { return application.keyWindow }
var screen: UIScreen { return UIScreen.main }
var cache: Cache { return Cache.shared }
//var store: DataStore { return DataStore.shared }

func mainQueue(_ f: @escaping () -> Void) { DispatchQueue.main.async(execute: f) }
