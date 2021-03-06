//
//  AppDelegate.swift
//  OKRiblets
//
//  Created by Jordan Guggenheim on 7/23/17.
//  Copyright © 2017 OkCupid. All rights reserved.
//

import UIKit

protocol OKAppDelegateHandler: class {
    func didFinishLaunching(with launchOptions: [UIApplicationLaunchOptionsKey: Any]?)
    func application(continue userActivity: NSUserActivity) -> Bool
    func application(open url: URL) -> Bool
}

protocol OKAppDelegate: class {
    func setRoot(viewController: UIViewController, animated: Bool)
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var rootRouter: OKRootRouter?
    weak var appDelegateHandler: OKAppDelegateHandler?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow()
        
        rootRouter = OKRootBuilder.build(components: self)
        appDelegateHandler?.didFinishLaunching(with: launchOptions)
        
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return appDelegateHandler?.application(open: url) ?? false
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        return appDelegateHandler?.application(continue: userActivity) ?? false
    }
    
}

extension AppDelegate: OKAppDelegate {
    
    func setRoot(viewController: UIViewController, animated: Bool) {
        guard let currentViewController = window?.rootViewController, animated else {
            window?.rootViewController = viewController
            return
        }
        
        // This forces a navigation bar height update
        window?.rootViewController = viewController
        window?.rootViewController = currentViewController
        
        UIView.transition(from: currentViewController.view, to: viewController.view, duration: 0.45, options: .transitionFlipFromLeft) { (done) in
            self.window?.rootViewController = viewController
        }
    }
    
}
