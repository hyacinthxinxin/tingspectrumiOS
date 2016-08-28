//
//  LecLightDimmingCell.swift
//  LeControl
//
//  Created by 新 范 on 16/8/27.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit

class LecLightDimmingCell: LecDeviceCell {    
    private var didSetupConstraints = false
    var switchView: LecSwitchView?
    var dimmingView: LecDimmingView?
    
    convenience init(device: LecDevice, cams: [LecCam]) {
        self.init(style: .Default, reuseIdentifier: LecConstants.ReuseIdentifier.LightDimmingCell)
        self.device = device
        self.cams = cams
        if let cs = self.cams {
            setupSubviews(cs)
        }
    }
    
    
    private func setupSubviews(cams: [LecCam]) {
        let switchCams =  cams.filter { $0.camType == 11 }
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
        let dimmingCams = cams.filter { $0.camType == 21 }
        if !dimmingCams.isEmpty {
            dimmingView = LecDimmingView()
            if let dimmingView = self.dimmingView {
                dimmingView.cams = dimmingCams
                contentView.addSubview(dimmingView)
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
        
        if let dimmingView = self.dimmingView {
            dimmingView.autoPinEdgeToSuperviewEdge(.Left)
            dimmingView.autoPinEdgeToSuperviewEdge(.Right)
            dimmingView.autoPinEdgeToSuperviewEdge(.Top, withInset: LecConstants.DeviceCellHeight.Switch)
            dimmingView.autoSetDimension(.Height, toSize: LecConstants.DeviceCellHeight.Dimming)
        }
    }
}
