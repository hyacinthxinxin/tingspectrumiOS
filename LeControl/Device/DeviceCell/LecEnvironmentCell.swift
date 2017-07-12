//
//  LecEnvironmentCell.swift
//  LeControl
//
//  Created by 范新 on 2017/7/12.
//  Copyright © 2017年 TingSpectrum. All rights reserved.
//

import UIKit
import PureLayout

class LecEnvironmentCell: LecDeviceCell {
    
    //环境
    private var environment_TemperatureView: LecDisplayView?
    private var environment_TemperatureTopMargin: CGFloat = 0.0
    private var environment_HumidityView: LecDisplayView?
    private var environment_HumidityTopMargin: CGFloat = 0.0
    private var environment_PMView: LecDisplayView?
    private var environment_PMTopMargin: CGFloat = 0.0
    
    convenience init(device: LecDevice) {
        self.init(style: .default, reuseIdentifier: LecConstants.ReuseIdentifier.DeviceCell)
        self.device = device
        setupSubviews()
    }
    
    func setupSubviews() {
        if let cams = self.device.cams {
            let environment_TemperatureCams =  LecDeviceCell.filterCams(cams, camTypes: LecConstants.DeviceCamTypes.EnvironmentTemperatrue)
            if !environment_TemperatureCams.isEmpty {
                environment_TemperatureView = LecDisplayView()
                environment_HumidityTopMargin += LecConstants.DeviceCellHeight.Environment_Temperature
                environment_PMTopMargin += LecConstants.DeviceCellHeight.Environment_Humidity
                if let cView = self.environment_TemperatureView {
                    cView.cams = environment_TemperatureCams
                    contentView.addSubview(cView)
                }
            }
            let environment_HumidityCams = LecDeviceCell.filterCams(cams, camTypes: LecConstants.DeviceCamTypes.EnvironmentHumidity)
            if !environment_TemperatureCams.isEmpty {
                environment_HumidityView = LecDisplayView()
                environment_PMTopMargin += LecConstants.DeviceCellHeight.Environment_Humidity
                if let cView = self.environment_HumidityView {
                    cView.cams = environment_HumidityCams
                    contentView.addSubview(cView)
                }
            }
            let environment_PMs = LecDeviceCell.filterCams(cams, camTypes: LecConstants.DeviceCamTypes.EnvironmentPM)
            if !environment_PMs.isEmpty {
                environment_PMView = LecDisplayView()
                if let cView = self.environment_PMView {
                    cView.cams = environment_PMs
                    contentView.addSubview(cView)
                }
            }
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let cView = self.environment_TemperatureView {
            self.positionCamView(cView, topMargin: environment_TemperatureTopMargin, height: LecConstants.DeviceCellHeight.Environment_Temperature)
        }
        
        if let cView = self.environment_HumidityView {
            self.positionCamView(cView, topMargin: environment_HumidityTopMargin, height: LecConstants.DeviceCellHeight.Environment_Humidity)
        }
        
        if let cView = self.environment_PMView {
            self.positionCamView(cView, topMargin: environment_PMTopMargin, height: LecConstants.DeviceCellHeight.Environment_PM)
        }
        
    }
}
