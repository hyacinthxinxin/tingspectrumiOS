//
//  LecLightCell.swift
//  LeControl
//
//  Created by 新 范 on 16/8/27.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit

class LecLightCell: LecDeviceCell {
    
    var switchView: LecSwitchView?
    
    convenience init(device: LecDevice, cams: [LecCam]) {
        self.init(style: .Default, reuseIdentifier: LecConstants.ReuseIdentifier.LightCell)
        self.device = device
        self.cams = cams
        if let cs = self.cams {
            switchView = LecSwitchView()
            if let switchView = self.switchView {
                contentView.addSubview(switchView)
                switchView.cams = cs.filter { $0.camType == 10 }
                if let device = self.device {
                    switchView.camNameLabel.text = device.deviceName
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
    }
    
}
