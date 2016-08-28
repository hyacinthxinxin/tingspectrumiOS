//
//  LecMasterViewController.swift
//  LeControl
//
//  Created by 新 范 on 16/8/23.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit

class LecFloorAndAreaViewController: UITableViewController {
    
    weak var areaDetailViewController: LecAreaDetailViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LecSocketManager.sharedSocket.dataModel.areas.count
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier(LecConstants.ReuseIdentifier.AreaCell, forIndexPath: indexPath) as? LecAreaCell {
            let area = LecSocketManager.sharedSocket.dataModel.areas[indexPath.row]
            cell.area = area
            return cell
        }
        assert(false, "The dequeued table view cell was of an unknown type!")
        return UITableViewCell()
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if view.window!.rootViewController!.traitCollection.horizontalSizeClass == .Compact {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            performSegueWithIdentifier(LecConstants.SegueIdentifier.ShowAreaDetail , sender: indexPath)
        } else {
            if splitViewController!.displayMode != .AllVisible {
                hideMasterPane()
            }
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! LecAreaCell
            if let area = cell.area {
                areaDetailViewController?.area = area
            }
        }
        
    }
    
    func hideMasterPane() {
        UIView.animateWithDuration(0.25, animations: {
            self.splitViewController!.preferredDisplayMode = .PrimaryHidden
            }, completion: { _ in
                self.splitViewController!.preferredDisplayMode = .Automatic
        })
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case LecConstants.SegueIdentifier.ShowAreaDetail:
                let areaDetailViewController = segue.destinationViewController as! LecAreaDetailViewController
                let indexPath = sender as! NSIndexPath
                let cell = tableView.cellForRowAtIndexPath(indexPath) as! LecAreaCell
                if let area = cell.area {
                    areaDetailViewController.area = area
                }
                
            case LecConstants.SegueIdentifier.ShowLogin:
                let navigationController = segue.destinationViewController as! UINavigationController
                let loginViewController = navigationController.topViewController as! LecLoginViewController
                loginViewController.delegate = self
                
            case LecConstants.SegueIdentifier.ShowConfig:
                let configViewController = segue.destinationViewController as! LecConfigViewController
                let userId = sender as! String
                configViewController.delegate = self
                configViewController.userId = userId
                
            default: break
                
            }
        }
    }
}


extension LecFloorAndAreaViewController: LecLoginViewControllerDelegate {
    func loginViewController(controller: LecLoginViewController, didLogInWithUserId userId: String) {
        dismissViewControllerAnimated(true, completion: {
            self.performSegueWithIdentifier(LecConstants.SegueIdentifier.ShowConfig, sender: userId)
        })
    }
}

extension LecFloorAndAreaViewController: LecConfigViewControllerDelegate {
    func configViewController(controller: LecConfigViewController, didChooseBuilding building: LecBuilding) {
        tableView.reloadData()
        navigationController?.popViewControllerAnimated(true)
        LecSocketManager.sharedSocket.connectHost()
    }
}
