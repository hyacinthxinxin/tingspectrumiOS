//
//  LecAirConditioningCell.swift
//  LeControl
//
//  Created by 范新 on 2017/4/8.
//  Copyright © 2017年 TingSpectrum. All rights reserved.
//

import UIKit

class LecAirConditioningCell: LecDeviceCell {
    
    //空调
    private var airConditioning_SwitchView: LecSwitchView?
    private var airConditioning_SwitchTopMargin: CGFloat = 0.0
    private var airConditioning_TemperatureView: LecTemperatureView?
    private var airConditioning_TemperatureTopMargin: CGFloat = 0.0
    private var airConditioning_SpeedView: LecSpeedView?
    private var airConditioning_SpeedTopMargin: CGFloat = 0.0
    private var airConditioning_ModelView: LecModelView?
    private var airConditioning_ModelTopMargin: CGFloat = 0.0
    
    convenience init(device: LecDevice) {
        self.init(style: .default, reuseIdentifier: LecConstants.ReuseIdentifier.DeviceCell)
        self.device = device
        setupSubviews()
    }
    
    func setupSubviews() {
        if let cams = self.device.cams {
            let airConditioning_SwitchCams =  LecDeviceCell.filterCams(cams, camTypes: LecConstants.DeviceCamTypes.AirConditioningSwitch)
            if !airConditioning_SwitchCams.isEmpty {
                airConditioning_SwitchView = LecSwitchView()
                airConditioning_TemperatureTopMargin += LecConstants.DeviceCellHeight.AirConditioning_Switch
                airConditioning_SpeedTopMargin += LecConstants.DeviceCellHeight.AirConditioning_Switch
                airConditioning_ModelTopMargin += LecConstants.DeviceCellHeight.AirConditioning_Switch
                if let cView = self.airConditioning_SwitchView {
                    cView.cams = airConditioning_SwitchCams
                    cView.camNameLabel.text = device.name
                    contentView.addSubview(cView)
                }
            }
            let airConditioning_TemperatureCams = LecDeviceCell.filterCams(cams, camTypes: LecConstants.DeviceCamTypes.AirConditioningTemperature)
            if !airConditioning_TemperatureCams.isEmpty {
                airConditioning_TemperatureView = LecTemperatureView()
                airConditioning_SpeedTopMargin += LecConstants.DeviceCellHeight.AirConditioning_Temperature
                airConditioning_ModelTopMargin += LecConstants.DeviceCellHeight.AirConditioning_Temperature
                if let cView = self.airConditioning_TemperatureView {
                    cView.cams = airConditioning_TemperatureCams
                    contentView.addSubview(cView)
                }
            }
            let airConditioning_SpeedCams = LecDeviceCell.filterCams(cams, camTypes: LecConstants.DeviceCamTypes.AirConditioningSpeed)
            if !airConditioning_SpeedCams.isEmpty {
                airConditioning_SpeedView = LecSpeedView(cams: airConditioning_SpeedCams)
                airConditioning_ModelTopMargin += LecConstants.DeviceCellHeight.AirConditioning_Speed
                if let cView = self.airConditioning_SpeedView {
                    cView.cams = airConditioning_SpeedCams
                    contentView.addSubview(cView)
                }
            }
            let airConditioning_ModelCams = LecDeviceCell.filterCams(cams, camTypes: LecConstants.DeviceCamTypes.AirConditioningModel)
            if !airConditioning_ModelCams.isEmpty {
                airConditioning_ModelView = LecModelView(cams: airConditioning_ModelCams)
                if let cView = self.airConditioning_ModelView {
                    contentView.addSubview(cView)
                }
            }
        }
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let cView = self.airConditioning_SwitchView {
            self.positionCamView(cView, topMargin: airConditioning_SwitchTopMargin, height: LecConstants.DeviceCellHeight.AirConditioning_Switch)
        }
        
        if let cView = self.airConditioning_TemperatureView {
            self.positionCamView(cView, topMargin: airConditioning_TemperatureTopMargin, height: LecConstants.DeviceCellHeight.AirConditioning_Temperature)
        }
        
        if let cView = self.airConditioning_SpeedView {
            self.positionCamView(cView, topMargin: airConditioning_SpeedTopMargin, height: LecConstants.DeviceCellHeight.AirConditioning_Speed)
        }
        
        if let cView = self.airConditioning_ModelView {
            self.positionCamView(cView, topMargin: airConditioning_ModelTopMargin, height: LecConstants.DeviceCellHeight.AirConditioning_Model)
        }
        
    }
}
