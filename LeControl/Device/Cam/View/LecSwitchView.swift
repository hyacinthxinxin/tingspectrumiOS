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
            if let _ = cams?.first {
                updateView()
            }
        }
    }
    
    @IBAction func switchCam(sender: UISwitch) {
        if let cam = cams?.first {
            cam.controlValue = sender.on ? 1: 0
            LecSocketManager.sharedSocket.sendMessageWithCam(cam)
        }
    }
    
    
}

extension LecSwitchView: LecCamViewUpdateDelegate {
    func updateView() {
        if let cam = cams?.first {
            camSwitch.on = cam.statusValue == 1
        }
    }
}