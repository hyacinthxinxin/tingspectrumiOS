//
//  LecFloorHeatingCell.swift
//  LeControl
//
//  Created by 新 范 on 16/8/27.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit

class LecFloorHeatingCell: LecDeviceCell {
    
    var switchView: LecSwitchView?
    var temperatureView: LecTemperatureView?
    
    convenience init(device: LecDevice, cams: [LecCam]) {
        self.init(style: .Default, reuseIdentifier: LecConstants.ReuseIdentifier.AirConditioningCell)
        self.device = device
        self.cams = cams
        if let cs = self.cams {
            setupSubviews(cs)
        }
    }
    
    private func setupSubviews(cams: [LecCam]) {
        let switchCams =  cams.filter { $0.camType == 13 }
        if !switchCams.isEmpty {
            switchView = LecSwitchView()
            if let switchView = self.switchView {
                switchView.cams = switchCams
                if let device = self.device {
                    switchView.camNameLabel.text = device.deviceName
                }
                contentView.addSubview(switchView)
            }
        }
        let temperatureCams = cams.filter { $0.camType == 23 }
        if !temperatureCams.isEmpty {
            temperatureView = LecTemperatureView()
            if let temperatureView = self.temperatureView {
                temperatureView.cams = temperatureCams
                contentView.addSubview(temperatureView)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let switchView = self.switchView {
            switchView.autoPinEdgeToSuperviewEdge(.Left)
            switchView.autoPinEdgeToSuperviewEdge(.Right)
            switchView.autoPinEdgeToSuperviewEdge(.Top)
            switchView.autoSetDimension(.Height, toSize: LecConstants.DeviceCellHeight.Switch)
        }
        
        if let temperatureView = self.temperatureView {
            temperatureView.autoPinEdgeToSuperviewEdge(.Left)
            temperatureView.autoPinEdgeToSuperviewEdge(.Right)
            temperatureView.autoPinEdgeToSuperviewEdge(.Top, withInset: LecConstants.DeviceCellHeight.Switch)
            temperatureView.autoSetDimension(.Height, toSize: LecConstants.DeviceCellHeight.Temperature)
        }
    }
}
