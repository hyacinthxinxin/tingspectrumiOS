//
//  LecDeviceViewController.swift
//  LeControl
//
//  Created by 新 范 on 16/8/23.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit
import PureLayout

class LecDeviceViewController: UIViewController {

    @IBOutlet weak var deviceTableView: UITableView!
    
    var devices: [LecDevice]! {
        didSet {
            let deviceIds = devices.map { $0.deviceId }
            cams = LecSocketManager.sharedSocket.dataModel.cams.filter{ deviceIds.contains( $0.deviceId ) }
        }
    }
    var cams: [LecCam]!
    
    deinit {
        print(#function)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deviceTableView.separatorColor = LecConstants.AppColor.SeparatorColor
        deviceTableView.cellLayoutMarginsFollowReadableWidth = false
        LecSocketManager.sharedSocket.camRefreshDelegate = self
        LecSocketManager.sharedSocket.sendStatusReadingMessageWithCams(cams.filter { $0.statusAddress != LecConstants.AddressInfo.EmptyAddress } )
    }
}

// MARK: - Table view data source

extension LecDeviceViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let device = devices[indexPath.row]
        let cams = self.cams.filter { $0.deviceId == device.deviceId }
        return LecDeviceCell.calculatorCellHeight(device, cams: cams)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let device = devices[indexPath.row]
        let cams = self.cams.filter { $0.deviceId == device.deviceId }
        let cell = LecDeviceCell(device: device, cams: cams)
        return cell
    }
}

// MARK: - Table view delegate

extension LecDeviceViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
        if cell.respondsToSelector(Selector("setSeparatorInset:")){
            cell.separatorInset = UIEdgeInsetsZero
        }
        if cell.respondsToSelector(Selector("setPreservesSuperviewLayoutMargins:")) {
            cell.preservesSuperviewLayoutMargins = false
        }
        if cell.respondsToSelector(Selector("setLayoutMargins:")){
            cell.layoutMargins = UIEdgeInsetsZero
        }
    }

    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }
}

// MARK: - Cam refresh delegate

extension LecDeviceViewController: LecCamRefreshDelegate {
    func refreshCam(feedbackAddress: String, statusValue: Int) {
        print("LecCamRefreshDelegate")
        for c in deviceTableView.visibleCells {
            for v in c.contentView.subviews {
                if let cv = v as? LecCamView {
                    if let cams = cv.cams {
                        let addrs = cams.map { $0.statusAddress }
                        if addrs.contains(feedbackAddress) {
                            cv.refreshState(feedbackAddress, statusValue: statusValue)
                        }
                    }
                }
            }
        }
    }
}