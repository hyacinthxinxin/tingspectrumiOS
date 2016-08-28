//
//  LecCurtainCell.swift
//  LeControl
//
//  Created by 新 范 on 16/8/27.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit

class LecCurtainCell: LecDeviceCell {
    var curtainNameLabel: UILabel?
    var curtainView: LecCurtainView?
    
    convenience init(device: LecDevice, cams: [LecCam]) {
        self.init(style: .Default, reuseIdentifier: LecConstants.ReuseIdentifier.CurtainCell)
        
        self.device = device
        self.cams = cams
        setupSubviews()
    }
    
    private func setupSubviews() {
        if let device = self.device {
            curtainNameLabel = UILabel()
            if let curtainNameLabel = self.curtainNameLabel {
                curtainNameLabel.text = device.deviceName
                curtainNameLabel.font = UIFont.systemFontOfSize(13)
                curtainNameLabel.textColor = UIColor.whiteColor()
                contentView.addSubview(curtainNameLabel)
            }
        }
        
        if let cams = self.cams {
            let curtainCams = cams.filter { 30 <= $0.camType && $0.camType < 40 }
            if !curtainCams.isEmpty {
                curtainView = LecCurtainView(cams: curtainCams)
                if let curtainView = self.curtainView {
                    contentView.addSubview(curtainView)
                }
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let curtainNameLabel = self.curtainNameLabel {
            curtainNameLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 14)
            curtainNameLabel.autoPinEdgeToSuperviewEdge(.Top, withInset: 10)
            if let curtainView = self.curtainView {
                curtainView.autoPinEdgeToSuperviewEdge(.Left)
                curtainView.autoPinEdgeToSuperviewEdge(.Right)
                curtainView.autoPinEdgeToSuperviewEdge(.Bottom)
                curtainView.autoPinEdge(.Top, toEdge: .Bottom, ofView: curtainNameLabel)
            }
        }
    }
}
