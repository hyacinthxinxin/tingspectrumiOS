//
//  LecAirConditioningCell.swift
//  LeControl
//
//  Created by 新 范 on 16/8/27.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit

class LecAirConditioningCell: LecDeviceCell {
    
    var switchView: LecSwitchView?
    var temperatureView: LecTemperatureView?
    var speedView: LecSpeedView?
    var modelView: LecModelView?
    
    convenience init(device: LecDevice, cams: [LecCam]) {
        self.init(style: .Default, reuseIdentifier: LecConstants.ReuseIdentifier.AirConditioningCell)
        self.device = device
        self.cams = cams
        setupSubviews()
    }
    
    private func setupSubviews() {
        if let cams = self.cams, let device = self.device {
            
            let switchCams =  cams.filter { $0.camType == 12 }
            if !switchCams.isEmpty {
                switchView = LecSwitchView()
                if let switchView = self.switchView {
                    switchView.cams = switchCams
                    switchView.camNameLabel.text = device.deviceName
                    contentView.addSubview(switchView)
                }
            }
            let temperatureCams = cams.filter { $0.camType == 22 }
            if !temperatureCams.isEmpty {
                temperatureView = LecTemperatureView()
                if let temperatureView = self.temperatureView {
                    temperatureView.cams = temperatureCams
                    contentView.addSubview(temperatureView)
                }
            }
            let speedCams = cams.filter { (40...44).contains($0.camType) }
            if !speedCams.isEmpty {
                speedView = LecSpeedView(cams: speedCams)
                if let speedView = self.speedView {
                    speedView.cams = speedCams
                    contentView.addSubview(speedView)
                }
            }
            let modelCams = cams.filter { (50...53).contains($0.camType) }
            if !modelCams.isEmpty {
                modelView = LecModelView(cams: modelCams)
                if let modelView = self.modelView {
                    contentView.addSubview(modelView)
                }
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
        
        if let speedView = self.speedView {
            speedView.autoPinEdgeToSuperviewEdge(.Left)
            speedView.autoPinEdgeToSuperviewEdge(.Right)
            speedView.autoPinEdgeToSuperviewEdge(.Top, withInset: LecConstants.DeviceCellHeight.Switch + LecConstants.DeviceCellHeight.Temperature)
            speedView.autoSetDimension(.Height, toSize: LecConstants.DeviceCellHeight.Speed)
        }
        
        if let modelView = self.modelView {
            modelView.autoPinEdgeToSuperviewEdge(.Left)
            modelView.autoPinEdgeToSuperviewEdge(.Right)
            modelView.autoPinEdgeToSuperviewEdge(.Top, withInset: LecConstants.DeviceCellHeight.Switch + LecConstants.DeviceCellHeight.Temperature + LecConstants.DeviceCellHeight.Speed)
            modelView.autoSetDimension(.Height, toSize: LecConstants.DeviceCellHeight.Model)
        }
    }
}
