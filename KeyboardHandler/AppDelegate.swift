//
//  AppDelegate.swift
//  KeyboardHandler
//
//  Created by Anbu on 04/01/18.
//  Copyright © 2018 Anbu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        KeyboardHandler.shared.enableKeyboardHandling()
        return true
    }
}

