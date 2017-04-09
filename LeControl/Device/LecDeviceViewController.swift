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
    
    var devices: [LecDevice]!
    
    deinit {
        lec_log(#function)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deviceTableView.separatorColor = LecConstants.AppColor.SeparatorColor
        deviceTableView.cellLayoutMarginsFollowReadableWidth = false
        LecSocketManager.sharedSocket.camRefreshDelegate = self
        _ = devices.map {
            if let cams = $0.cams {
                LecSocketManager.sharedSocket.sendStatusReadingMessageWithCams(cams.filter {
                    $0.statusAddress != LecConstants.AddressInfo.EmptyAddress
                })
            }
        }
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let device = devices[(indexPath as NSIndexPath).row]
        return LecDeviceCell.calculatorCellHeight(by: device)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getDeviceCell(by: devices[(indexPath as NSIndexPath).row])
    }
    
    fileprivate func getDeviceCell(by device:LecDevice) -> LecDeviceCell {
        switch device.iType {
        case .light:
            let cell = LecLightCell(device: device)
            return cell
        case .curtain:
            let cell = LecCurtainCell(device: device)
            return cell
        case .airConditioning:
            let cell = LecAirConditioningCell(device: device)
            return cell
        case .floorHeating:
            let cell = LecFloorHeatingCell(device: device)
            return cell
        case .freshAir:
            let cell = LecFreshAirCell(device: device)
            return cell
        default:
            return LecDeviceCell()
        }
    }
    
    func getDevice(with camAddress: String) -> LecDevice {
        for device in devices {
            if let cams = device.cams {
                if cams.contains(where: { $0.statusAddress == camAddress }) {
                    return device
                }
            }
        }
        return LecDevice()
    }
    
    func getCam(with camAddress: String) -> LecCam {
        for device in devices {
            if let cams = device.cams {
                for cam in cams {
                    if cam.statusAddress == camAddress  {
                        return cam
                    }
                }
            }
        }
        return LecCam()
    }
    
    func getCamParentDevice(by deviceId: Int) -> LecDevice? {
        return devices.filter({ $0.iId == deviceId }).first
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
    func refreshCam(_ feedbackAddress: String, feedbackValue: Int) {
        let cam = getCam(with: feedbackAddress)
        if let device = getCamParentDevice(by: cam.sId) {
            lec_log(cam.iType)
            if cam.isSingleControl {
                cam.controlValue = feedbackValue
            } else if LecConstants.DeviceCamTypes.AirConditioningSpeed.contains(cam.iType) {
                if let cams = device.cams?.filter({ LecConstants.DeviceCamTypes.AirConditioningSpeed.contains($0.iType) }) {
                    for c in cams {
                        if c.controlValue == feedbackValue {
                            c.isChecked = true
                        } else {
                            c.isChecked = false
                        }
                    }
                }
            } else if LecConstants.DeviceCamTypes.AirConditioningModel.contains(cam.iType) {
                if let cams = device.cams?.filter({ LecConstants.DeviceCamTypes.AirConditioningModel.contains($0.iType) }) {
                    for c in cams {
                        if c.controlValue == feedbackValue {
                            c.isChecked = true
                        } else {
                            c.isChecked = false
                        }
                    }
                }
            } else if LecConstants.DeviceCamTypes.FreshAirSpeed.contains(cam.iType) {
                if let cams = device.cams?.filter({ LecConstants.DeviceCamTypes.FreshAirSpeed.contains($0.iType) }) {
                    for c in cams {
                        if c.controlValue == feedbackValue {
                            c.isChecked = true
                        } else {
                            c.isChecked = false
                        }
                    }
                }
            }
            lec_log(cam.isChecked)
            if let row = devices.index(of: device) {
                let indexPath = IndexPath(row: row, section: 0)
                deviceTableView.reloadRows(at: [indexPath], with: .none)
            }
        }
        
    }
    
}
