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
    
    override var cams: [LecCam]! {
        didSet {
            if let cam = cams.first {
                dimmingSlider.value = Float(cam.controlValue) / 255
            }
        }
    }

    @IBAction func sliderDimming(_ sender: UISlider) {
        if let cam = cams?.first {
            cam.controlValue = Int(sender.value * 255)
            LecSocketManager.sharedSocket.sendMessageWithCam(cam)
        }
    }
    
}
