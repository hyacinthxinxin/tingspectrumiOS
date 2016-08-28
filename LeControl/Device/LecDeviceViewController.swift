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
        LecSocketManager.sharedSocket.camRefreshDelegate = self
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
        switch device.deviceType {
        case .Scene:
            fatalError("Should never get here")
        case .Light:
            return LecConstants.DeviceCellHeight.Switch
        case .LightDimming:
            return LecConstants.DeviceCellHeight.Switch + LecConstants.DeviceCellHeight.Dimming
        case .Curtain:
            return LecConstants.DeviceCellHeight.Curtain
        case .AirConditioning:
            return LecConstants.DeviceCellHeight.Switch + LecConstants.DeviceCellHeight.Temperature + LecConstants.DeviceCellHeight.Speed + LecConstants.DeviceCellHeight.Model
        case .FloorHeating:
            return LecConstants.DeviceCellHeight.Switch + LecConstants.DeviceCellHeight.Temperature
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let device = devices[indexPath.row]
        let cams = self.cams.filter { $0.deviceId == device.deviceId }
        
        switch device.deviceType {
        case .Scene:
            fatalError("Should never get here")
        case .Light:
            let cell = LecLightCell(device: device, cams: cams)
            return cell
        case .LightDimming:
            let cell = LecLightDimmingCell(device: device, cams: cams)
            return cell
        case .Curtain:
            let cell = LecCurtainCell(device: device, cams: cams)
            return cell
        case .AirConditioning:
            let cell = LecAirConditioningCell(device: device, cams:  cams)
            return cell
        case .FloorHeating:
            let cell = LecFloorHeatingCell(device: device, cams:  cams)
            return cell
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - Table view delegate

extension LecDeviceViewController: UITableViewDelegate {
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
                if let cv = v as? LecSwitchView {
                    cv.updateView()
                } else if let cv = v as? LecDimmingView {
                    cv.updateView()
                } else if let cv = v as? LecTemperatureView {
                    cv.updateView()
                } else if let cv = v as? LecSpeedView {
                    cv.updateView()
                } else if let cv = v as? LecModelView {
                    cv.updateView()
                }
            }
        }
    }
}