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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    @objc(tableView:heightForRowAtIndexPath:) func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let device = devices[(indexPath as NSIndexPath).row]
        let cams = self.cams.filter { $0.deviceId == device.deviceId }
        return LecDeviceCell.calculatorCellHeight(device, cams: cams)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let device = devices[(indexPath as NSIndexPath).row]
        let cams = self.cams.filter { $0.deviceId == device.deviceId }
        let cell = LecDeviceCell(device: device, cams: cams)
        return cell
    }
}

// MARK: - Table view delegate

extension LecDeviceViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
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

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}

// MARK: - Cam refresh delegate

extension LecDeviceViewController: LecCamRefreshDelegate {
    func refreshCam(_ feedbackAddress: String, statusValue: Int) {
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
