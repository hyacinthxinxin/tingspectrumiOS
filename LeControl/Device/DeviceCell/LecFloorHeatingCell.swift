//
//  LecFloorHeatingCell.swift
//  LeControl
//
//  Created by 范新 on 2017/4/8.
//  Copyright © 2017年 TingSpectrum. All rights reserved.
//

import UIKit

class LecFloorHeatingCell: LecDeviceCell {
    
    var floorHeating_SwitchView: LecSwitchView?
    var floorHeating_SwitchTopMargin: CGFloat = 0.0
    var floorHeating_TemperatureView: LecTemperatureView?
    var floorHeating_TemperatureTopMargin: CGFloat = 0.0
    
    convenience init(device: LecDevice) {
        self.init(style: .default, reuseIdentifier: LecConstants.ReuseIdentifier.DeviceCell)
        self.device = device
        setupSubviews()
    }
    
    func setupSubviews() {
        if let cams = self.device.cams {
            let floorHeating_SwitchCams =  LecDeviceCell.filterCams(cams, camTypes: LecConstants.DeviceCamTypes.FloorHeatingSwitch)
            if !floorHeating_SwitchCams.isEmpty {
                floorHeating_SwitchView = LecSwitchView()
                floorHeating_TemperatureTopMargin += LecConstants.DeviceCellHeight.FloorHeating_Switch
                if let cView = self.floorHeating_SwitchView {
                    cView.cams = floorHeating_SwitchCams
                    cView.camNameLabel.text = device.name
                    contentView.addSubview(cView)
                }
            }
            let floorHeating_TemperatureCams = LecDeviceCell.filterCams(cams, camTypes: LecConstants.DeviceCamTypes.FloorHeatingTemperature)
            if !floorHeating_TemperatureCams.isEmpty {
                floorHeating_TemperatureView = LecTemperatureView()
                if let cView = self.floorHeating_TemperatureView {
                    cView.cams = floorHeating_TemperatureCams
                    contentView.addSubview(cView)
                }
            }
            
        }
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let cView = self.floorHeating_SwitchView {
            positionCamView(cView, topMargin: floorHeating_SwitchTopMargin, height: LecConstants.DeviceCellHeight.FloorHeating_Switch)
        }
        
        if let cView = self.floorHeating_TemperatureView {
            positionCamView(cView, topMargin: floorHeating_TemperatureTopMargin, height: LecConstants.DeviceCellHeight.FloorHeating_Temperature)
        }

    }
}
