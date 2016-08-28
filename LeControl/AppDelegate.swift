//
//  AppDelegate.swift
//  LeControl
//
//  Created by 新 范 on 16/8/23.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var splitViewController: UISplitViewController {
        return window!.rootViewController as! UISplitViewController
    }
    
    var floorAndAreaNavigationController: UINavigationController {
        return splitViewController.viewControllers.first as! UINavigationController
    }
    
    var floorAndAreaViewController: LecFloorAndAreaViewController {
        return floorAndAreaNavigationController.topViewController as! LecFloorAndAreaViewController
    }
    
    var areaDetailNavigationController: UINavigationController {
        return splitViewController.viewControllers.last as! UINavigationController
    }
    
    var areaDetailViewController: LecAreaDetailViewController {
        return areaDetailNavigationController.topViewController as! LecAreaDetailViewController
    }
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        LecSocketManager.sharedSocket.connectHost()
        customizeAppearance()
        setupSplitViewController()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }
    
    // MARK: - Custom Appearance
    
    func customizeAppearance() {
        window!.tintColor = UIColor.whiteColor()
    }

    func setupSplitViewController() {
        areaDetailViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
        floorAndAreaViewController.areaDetailViewController = areaDetailViewController
        splitViewController.delegate = self
    }
}

// MARK: - Split view delegate

extension AppDelegate: UISplitViewControllerDelegate {
    func splitViewController(svc: UISplitViewController, willChangeToDisplayMode displayMode: UISplitViewControllerDisplayMode) {
        if displayMode == .PrimaryOverlay {
            svc.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController, ontoPrimaryViewController primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? LecAreaDetailViewController else { return false }
        if topAsDetailController.area == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        return false
    }
 
}
