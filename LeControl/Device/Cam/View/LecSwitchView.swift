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
    
    @IBAction func switchCam(_ sender: UISwitch) {
        if let cam = cams?.first {
            cam.controlValue = sender.isOn ? 1: 0
            LecSocketManager.sharedSocket.sendMessageWithCam(cam)
        }
    }
    
    override func refreshState(_ feedbackAddress: String, statusValue: Int) {
        if let cam = cams?.first {
            cam.statusValue = statusValue
            camNameLabel.textColor = cam.statusValue == 1 ? UIColor.white: UIColor(white: 1.0, alpha: 0.5)
            camSwitch.isOn = cam.statusValue == 1
        }
    }
}
