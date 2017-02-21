//
//  LecDimmingView.swift
//  LeControl
//
//  Created by 新 范 on 16/8/27.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit
import PureLayout

class LecDimmingView: LecCamViewWithNib {
    
    @IBOutlet weak var dimmingSlider: UISlider!
    
    override var cams: [LecCam]? {
        didSet {
            if let cam = self.cams?.first {
                refreshState(cam.statusAddress, statusValue: cam.statusValue)
            }
        }
    }
    
    override func refreshState(_ feedbackAddress: String, statusValue: Int) {
        if let cam = self.cams?.first {
            cam.statusValue = statusValue
            dimmingSlider.value = Float(cam.statusValue) / 225
        }
    }

    @IBAction func sliderDimming(_ sender: UISlider) {
        if let cam = cams?.first {
            cam.controlValue = Int(sender.value * 225)
            LecSocketManager.sharedSocket.sendMessageWithCam(cam)
        }
    }
    
}
