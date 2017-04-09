//
//  LecLightCell.swift
//  LeControl
//
//  Created by 范新 on 2017/4/8.
//  Copyright © 2017年 TingSpectrum. All rights reserved.
//

import UIKit

class LecLightCell: LecDeviceCell {
    
    //灯光开关和调光
    var light_SwitchView: LecSwitchView?
    var light_SwitchTopMargin: CGFloat = 0.0
    var light_DimmingView: LecDimmingView?
    var light_DimmingTopMargin: CGFloat = 0.0
    
    convenience init(device: LecDevice) {
        self.init(style: .default, reuseIdentifier: LecConstants.ReuseIdentifier.DeviceCell)
        self.device = device
        setupSubviews()
    }
    
    func setupSubviews() {
        if let device = self.device, let cams = device.cams {
            let light_SwitchCams = LecDeviceCell.filterCams(cams, camTypes: LecConstants.DeviceCamTypes.LightSwitch)
            if !light_SwitchCams.isEmpty {
                light_SwitchView = LecSwitchView()
                light_DimmingTopMargin += LecConstants.DeviceCellHeight.Light_Switch
                if let cView = self.light_SwitchView {
                    cView.cams = light_SwitchCams
                    cView.camNameLabel.text = device.name
                    contentView.addSubview(cView)
                }
            }
            let light_DimmingCams = LecDeviceCell.filterCams(cams, camTypes: LecConstants.DeviceCamTypes.LightDimming)
            if !light_DimmingCams.isEmpty {
                light_DimmingView = LecDimmingView()
                if let cView = self.light_DimmingView {
                    cView.cams = light_DimmingCams
                    contentView.addSubview(cView)
                }
                
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let cView = self.light_SwitchView {
            self.positionCamView(cView, topMargin: light_SwitchTopMargin, height: LecConstants.DeviceCellHeight.Light_Switch)
        }
        
        if let cView = self.light_DimmingView {
            self.positionCamView(cView, topMargin: light_DimmingTopMargin, height: LecConstants.DeviceCellHeight.Light_Dimming)
        }
    }
    
}
