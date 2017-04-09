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
        temperatureSlider.popUpViewColor = UIColor.clear
        temperatureSlider.font = UIFont.systemFont(ofSize: 15)
        let formatter = NumberFormatter()
        formatter.positiveSuffix = "°C"
        temperatureSlider.numberFormatter = formatter
        temperatureSlider.showPopUpView(animated: false)
    }
    
    override var cams: [LecCam]? {
        didSet {
            if let cam = cams?.first {
                switch cam.iType {
                case 41:
                    temperatureSlider.thumbTintColor = UIColor.white
                    temperatureSlider.minimumTrackTintColor = LecConstants.AppColor.CamTintColor
                    temperatureSlider.minimumValue = 19
                    temperatureSlider.maximumValue = 32
                case 51:
                    temperatureSlider.thumbTintColor = "#54377b".hexColor
                    temperatureSlider.minimumTrackTintColor = "#54377b".hexColor
                    temperatureSlider.minimumValue = 15
                    temperatureSlider.maximumValue = 33
                default:
                    break
                }
                temperatureSlider.value = Float(cam.controlValue)
            }
        }
    }
    
    @IBAction func sliderTemperature(_ sender: UISlider) {
        if let cam = cams?.first {
            cam.controlValue = Int(sender.value)
            LecSocketManager.sharedSocket.sendMessageWithCam(cam)
        }
    }
}
