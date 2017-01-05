//
//  LecMasterViewController.swift
//  LeControl
//
//  Created by 新 范 on 16/8/23.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


class LecFloorAndAreaViewController: UITableViewController {
    
    weak var areaDetailViewController: LecAreaDetailViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorColor = UIColor(white: 1, alpha: 0.07)
        tableView.cellLayoutMarginsFollowReadableWidth = false
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LecSocketManager.sharedSocket.dataModel.areas.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)){
            cell.separatorInset = UIEdgeInsets.zero
        }
        if cell.responds(to: #selector(setter: UIView.preservesSuperviewLayoutMargins)) {
            cell.preservesSuperviewLayoutMargins = false
        }
        if cell.responds(to: #selector(setter: UIView.layoutMargins)){
            cell.layoutMargins = UIEdgeInsets.zero
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: LecConstants.ReuseIdentifier.AreaCell, for: indexPath) as? LecAreaCell {
            let area = LecSocketManager.sharedSocket.dataModel.areas[(indexPath as NSIndexPath).row]
            cell.area = area
            return cell
        }
        assert(false, "The dequeued table view cell was of an unknown type!")
        return UITableViewCell()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if view.window!.rootViewController!.traitCollection.horizontalSizeClass == .compact {
            tableView.deselectRow(at: indexPath, animated: true)
            performSegue(withIdentifier: LecConstants.SegueIdentifier.ShowAreaDetail , sender: indexPath)
        } else {
            if splitViewController!.displayMode != .allVisible {
                hideMasterPane()
            }
            let cell = tableView.cellForRow(at: indexPath) as! LecAreaCell
            if let area = cell.area {
                areaDetailViewController?.area = area
                if areaDetailViewController?.navigationController?.viewControllers.count > 1 {
                    _ = areaDetailViewController?.navigationController?.popToRootViewController(animated: false)
                }
            }
        }
    }
    
    func hideMasterPane() {
        UIView.animate(withDuration: 0.25, animations: {
            self.splitViewController!.preferredDisplayMode = .primaryHidden
        }, completion: { _ in
            self.splitViewController!.preferredDisplayMode = .automatic
        })
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let backItem = UIBarButtonItem()
        backItem.title = "返回"
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
        
        if let identifier = segue.identifier {
            switch identifier {
            case LecConstants.SegueIdentifier.ShowAreaDetail:
                let areaDetailViewController = segue.destination as! LecAreaDetailViewController
                let indexPath = sender as! IndexPath
                let cell = tableView.cellForRow(at: indexPath) as! LecAreaCell
                if let area = cell.area {
                    areaDetailViewController.area = area
                }
            case LecConstants.SegueIdentifier.ShowLogin:
                let navigationController = segue.destination as! UINavigationController
                let loginViewController = navigationController.topViewController as! LecLoginViewController
                loginViewController.delegate = self
                
            case LecConstants.SegueIdentifier.ShowConfig:
                let configViewController = segue.destination as! LecConfigViewController
                let userId = sender as! String
                configViewController.delegate = self
                configViewController.userId = userId
                
            default: break
                
            }
        }
    }
}


extension LecFloorAndAreaViewController: LecLoginViewControllerDelegate {
    func loginViewController(_ controller: LecLoginViewController, didLogInWithUserId userId: String) {
        dismiss(animated: true, completion: {
            self.performSegue(withIdentifier: LecConstants.SegueIdentifier.ShowConfig, sender: userId)
        })
    }
}

extension LecFloorAndAreaViewController: LecConfigViewControllerDelegate {
    func configViewController(_ controller: LecConfigViewController, didChooseBuilding building: LecBuilding) {
        tableView.reloadData()
        _ = navigationController?.popViewController(animated: true)
    }
}
