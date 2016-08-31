//
//  LecSwitchView.swift
//  LeControl
//
//  Created by 新 范 on 16/8/27.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit
import PureLayout

class LecSwitchView: LecCamViewWithNib {
    
    @IBOutlet weak var camNameLabel: UILabel!
    @IBOutlet weak var camSwitch: UISwitch!

    override var cams: [LecCam]? {
        didSet {
            if let cam = cams?.first {
                refreshState(cam.statusAddress, statusValue: cam.statusValue)
            }
        }
    }
    
    @IBAction func switchCam(sender: UISwitch) {
        if let cam = cams?.first {
            cam.controlValue = sender.on ? 1: 0
            LecSocketManager.sharedSocket.sendMessageWithCam(cam)
        }
    }
    
    override func refreshState(feedbackAddress: String, statusValue: Int) {
        if let cam = cams?.first {
            camNameLabel.textColor = cam.statusValue == 1 ? UIColor.whiteColor(): UIColor(white: 1.0, alpha: 0.5)
            camSwitch.on = cam.statusValue == 1
        }
    }
}