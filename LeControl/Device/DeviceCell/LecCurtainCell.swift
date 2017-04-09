//
//  LecCurtainCell.swift
//  LeControl
//
//  Created by 范新 on 2017/4/8.
//  Copyright © 2017年 TingSpectrum. All rights reserved.
//

import UIKit

class LecCurtainCell: LecDeviceCell {

    //窗帘
    var curtain_CurtainView: LecCurtainView?
    var curtain_CurtainTopMargin: CGFloat = 0.0
    
    convenience init(device: LecDevice) {
        self.init(style: .default, reuseIdentifier: LecConstants.ReuseIdentifier.DeviceCell)
        self.device = device
        setupSubviews()
    }
    
    func setupSubviews() {
        if let cams = self.device.cams {
            let curtain_Cams = LecDeviceCell.filterCams(cams, camTypes: LecConstants.DeviceCamTypes.Curtain)
            if !curtain_Cams.isEmpty {
                curtain_CurtainView = LecCurtainView(cams: curtain_Cams)
                if let cView = self.curtain_CurtainView {
                    cView.curtainNameLabel?.text = device.name
                    contentView.addSubview(cView)
                }
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if let cView = self.curtain_CurtainView {
            self.positionCamView(cView, topMargin: curtain_CurtainTopMargin, height: LecConstants.DeviceCellHeight.Curtain_Curtain)
        }

    }
}
