//
//  AppDelegate.swift
//  LeControl
//
//  Created by 新 范 on 16/8/23.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit
import CoreData

enum LecEnvironment {
    case develop
    case product
    var httpAddress: String {
        switch self {
        case .develop:
            return LecConstants.NetworkAddress.DevelopAddress
        case .product:
            return LecConstants.NetworkAddress.ProductAddress
        }
    }
}

let environment: LecEnvironment = LecEnvironment.develop

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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        LecSocketManager.sharedSocket.startConnectHost()
        customizeAppearance()
        setupSplitViewController()
        return true
    }
    
    // MARK: - Custom Appearance
    
    func customizeAppearance() {
        /*
        let barAppearance = UIBarButtonItem.appearance()
        barAppearance.setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), forBarMetrics: .Default)
        */
        window!.tintColor = UIColor.white
    }

    func setupSplitViewController() {
        areaDetailViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
        floorAndAreaViewController.areaDetailViewController = areaDetailViewController
        
        if !(window!.rootViewController!.traitCollection.horizontalSizeClass == .compact) {
            areaDetailViewController.area = LecSocketManager.sharedSocket.dataModel.areas[0]

        }
        splitViewController.delegate = self
        
    }

}

// MARK: - Split view delegate

extension AppDelegate: UISplitViewControllerDelegate {
    func splitViewController(_ svc: UISplitViewController, willChangeTo displayMode: UISplitViewControllerDisplayMode) {
        if displayMode == .primaryOverlay {
            svc.dismiss(animated: true, completion: nil)
        }
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? LecAreaDetailViewController else { return false }
        if topAsDetailController.area == nil {
            return true
        }
        return false
    }
 
}
