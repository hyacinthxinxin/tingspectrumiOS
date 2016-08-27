//
//  LecDeviceViewController.swift
//  LeControl
//
//  Created by 新 范 on 16/8/23.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit

class LecDeviceViewController: UIViewController {

    var dataModel: LecDataModel!

    @IBOutlet weak var deviceTableView: UITableView!
    
    var devices: [LecDevice]! {
        didSet {
            let deviceIds = devices.map { $0.deviceId }
            cams = dataModel.cams.filter{ deviceIds.contains( $0.deviceId ) }
        }
    }
    var cams: [LecCam]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCellNib()
    }
    
    private func registerCellNib() {
        var cellNib = UINib(nibName: LecConstants.ReuseIdentifier.LightCell, bundle: nil)
        deviceTableView.registerNib(cellNib, forCellReuseIdentifier: LecConstants.ReuseIdentifier.LightCell)
        cellNib = UINib(nibName: LecConstants.ReuseIdentifier.LightDimmingCell, bundle: nil)
        deviceTableView.registerNib(cellNib, forCellReuseIdentifier: LecConstants.ReuseIdentifier.LightDimmingCell)
        cellNib = UINib(nibName: LecConstants.ReuseIdentifier.CurtainCell, bundle: nil)
        deviceTableView.registerNib(cellNib, forCellReuseIdentifier: LecConstants.ReuseIdentifier.CurtainCell)
        cellNib = UINib(nibName: LecConstants.ReuseIdentifier.AirConditioningCell, bundle: nil)
        deviceTableView.registerNib(cellNib, forCellReuseIdentifier: LecConstants.ReuseIdentifier.AirConditioningCell)
        cellNib = UINib(nibName: LecConstants.ReuseIdentifier.FloorHeatingCell, bundle: nil)
        deviceTableView.registerNib(cellNib, forCellReuseIdentifier: LecConstants.ReuseIdentifier.FloorHeatingCell)
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
            return 44
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let device = devices[indexPath.row]
        
        switch device.deviceType {
        case .Scene:
            fatalError("Should never get here")
        case .Light:
            let cell = tableView.dequeueReusableCellWithIdentifier(LecConstants.ReuseIdentifier.LightCell, forIndexPath: indexPath) as! LecLightCell
            cell.device = device
            cell.cams = cams.filter { $0.deviceId == device.deviceId }
            return cell
        case .LightDimming:
            let cell = tableView.dequeueReusableCellWithIdentifier(LecConstants.ReuseIdentifier.LightDimmingCell, forIndexPath: indexPath) as! LecLightDimmingCell
            cell.device = device
            cell.cams = cams.filter { $0.deviceId == device.deviceId }
            return cell
        case .Curtain:
            let cell = tableView.dequeueReusableCellWithIdentifier(LecConstants.ReuseIdentifier.CurtainCell, forIndexPath: indexPath) as! LecCurtainCell
            cell.device = device
            cell.cams = cams.filter { $0.deviceId == device.deviceId }
            return cell
        case .AirConditioning:
            let cell = tableView.dequeueReusableCellWithIdentifier(LecConstants.ReuseIdentifier.AirConditioningCell, forIndexPath: indexPath) as! LecAirConditioningCell
            cell.device = device
            cell.cams = cams.filter { $0.deviceId == device.deviceId }
            return cell
        case .FloorHeating:
            let cell = tableView.dequeueReusableCellWithIdentifier(LecConstants.ReuseIdentifier.FloorHeatingCell, forIndexPath: indexPath) as! LecFloorHeatingCell
            cell.device = device
            cell.cams = cams.filter { $0.deviceId == device.deviceId }
            return cell
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - Table view data source

extension LecDeviceViewController: UITableViewDelegate {
    
}