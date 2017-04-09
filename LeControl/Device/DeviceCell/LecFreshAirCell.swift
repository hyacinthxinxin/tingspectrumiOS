//
//  LecFreshAirCell.swift
//  LeControl
//
//  Created by 范新 on 2017/4/8.
//  Copyright © 2017年 TingSpectrum. All rights reserved.
//

import UIKit

class LecFreshAirCell: LecDeviceCell {
    //新风
    var freshAir_SwitchView: LecSwitchView?
    var freshAir_SwitchTopMargin: CGFloat = 0.0
    var freshAir_SpeedView: LecSpeedView?
    var freshAir_SpeedTopMargin: CGFloat = 0.0
    
    convenience init(device: LecDevice) {
        self.init(style: .default, reuseIdentifier: LecConstants.ReuseIdentifier.DeviceCell)
        self.device = device
        setupSubviews()
    }
    
    func setupSubviews() {
        if let cams = self.device.cams {
            let freshAir_SwitchCams =  LecDeviceCell.filterCams(cams, camTypes: LecConstants.DeviceCamTypes.FreshAirSwitch)
            if !freshAir_SwitchCams.isEmpty {
                freshAir_SwitchView = LecSwitchView()
                freshAir_SpeedTopMargin += LecConstants.DeviceCellHeight.FreshAir_Switch
                if let cView = self.freshAir_SwitchView {
                    cView.cams = freshAir_SwitchCams
                    cView.camNameLabel.text = device.name
                    contentView.addSubview(cView)
                }
            }
            let freshAir_SpeedCams = LecDeviceCell.filterCams(cams, camTypes: LecConstants.DeviceCamTypes.FreshAirSpeed)
            if !freshAir_SpeedCams.isEmpty {
                freshAir_SpeedView = LecSpeedView(cams: freshAir_SpeedCams)
                if let cView = self.freshAir_SpeedView {
                    cView.cams = freshAir_SpeedCams
                    contentView.addSubview(cView)
                }
            }
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let cView = self.freshAir_SwitchView {
            positionCamView(cView, topMargin: freshAir_SwitchTopMargin, height: LecConstants.DeviceCellHeight.FreshAir_Switch)
        }
        if let cView = self.freshAir_SpeedView {
            positionCamView(cView, topMargin: freshAir_SpeedTopMargin, height: LecConstants.DeviceCellHeight.FreshAir_Speed)
        }
    }
    
}
