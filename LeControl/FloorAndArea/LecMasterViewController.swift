//
//  LecMasterViewController.swift
//  LeControl
//
//  Created by 新 范 on 16/8/23.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit

class LecMasterViewController: UITableViewController {
    
    var dataModel: LecDataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.areas.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier(LecConstants.ReuseIdentifier.AreaCell, forIndexPath: indexPath) as? LecAreaCell {
            let area = dataModel.areas[indexPath.row]
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
            //            if case .Results(let list) = search.state {
            if splitViewController!.displayMode != .AllVisible {
                //                    hideMasterPane()
            }
            //                splitViewDetail?.searchResult = list[indexPath.row]
            //            }
        }
        
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
                    areaDetailViewController.dataModel = dataModel
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
                configViewController.dataModel = dataModel
                configViewController.userId = userId
                
            default: break
                
            }
        }
    }
}

extension LecMasterViewController: LecLoginViewControllerDelegate {
    func loginViewController(controller: LecLoginViewController, didLogInWithUserId userId: String) {
        dismissViewControllerAnimated(true, completion: {
            self.performSegueWithIdentifier(LecConstants.SegueIdentifier.ShowConfig, sender: userId)
        })
    }
}

extension LecMasterViewController: LecConfigViewControllerDelegate {
    func configViewController(controller: LecConfigViewController, didChooseBuilding building: LecBuilding) {
        tableView.reloadData()
        navigationController?.popViewControllerAnimated(true)
    }
}
