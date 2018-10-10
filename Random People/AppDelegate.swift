//
//  AppDelegate.swift
//  Random People
//
//  Created by Maxim Lanskoy on 09.10.2018.
//  Copyright © 2018 Lanskoy. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var isNetworkActivityIndicatorEnabled: Bool = true {
        didSet {
            NetworkActivityIndicatorManager.shared.isEnabled = isNetworkActivityIndicatorEnabled;
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.configureAppSettings()
        return true
    }
    
    //MARK: - Private
    private func configureAppSettings() {
        // Enable and configure ActivityManager.
        NetworkActivityIndicatorManager.shared.isEnabled = true
        NetworkActivityIndicatorManager.shared.startDelay = 0
    }
}

