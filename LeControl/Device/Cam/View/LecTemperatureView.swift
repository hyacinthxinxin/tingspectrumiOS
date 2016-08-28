//
//  LecTemperatureView.swift
//  LeControl
//
//  Created by 新 范 on 16/8/28.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit
import ASValueTrackingSlider

class LecTemperatureView: LecCamViewWithNib {

    @IBOutlet weak var temperatureSlider: ASValueTrackingSlider!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }
    
    func setupSubviews() {
        temperatureSlider.setMaxFractionDigitsDisplayed(0)
        temperatureSlider.popUpViewColor = UIColor.clearColor()
        temperatureSlider.font = UIFont.systemFontOfSize(15)
        let formatter = NSNumberFormatter()
        formatter.positiveSuffix = "°C"
        temperatureSlider.numberFormatter = formatter
        temperatureSlider.showPopUpViewAnimated(false)
    }
    
    override var cams: [LecCam]? {
        didSet {
            if let cam = cams?.first {
                switch cam.camType {
                case 22:
                    temperatureSlider.thumbTintColor = UIColor.whiteColor()
                    temperatureSlider.minimumTrackTintColor = LecConstants.AppColor.CamTintColor
                case 23:
                    temperatureSlider.thumbTintColor = "#54377b".hexColor
                    temperatureSlider.minimumTrackTintColor = "#54377b".hexColor
                default:
                    break
                }
                temperatureSlider.minimumValue = Float(cam.minControlValue)
                temperatureSlider.maximumValue = Float(cam.maxControlValue)
                updateView()
            }
        }
    }
    
    @IBAction func sliderTemperature(sender: UISlider) {
        if let cam = cams?.first {
//            cam.controlValue = cam.minControlValue + Int(sender.value * Float(cam.maxControlValue - cam.minControlValue))
            cam.controlValue = Int(sender.value)
            LecSocketManager.sharedSocket.sendMessageWithCam(cam)
        }
    }
}

extension LecTemperatureView: LecCamViewUpdateDelegate {
    func updateView() {
        if let cam = cams?.first {
            temperatureSlider.value = Float(cam.statusValue)
            //        temperatureSlider.value = Float(cam.statusValue) / Float(cam.maxStatusValue - cam.minStatusValue)
        }
    }
}