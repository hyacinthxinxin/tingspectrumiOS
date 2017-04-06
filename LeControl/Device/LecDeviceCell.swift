//
//  LecDeviceCell.swift
//  LeControl
//
//  Created by 新 范 on 16/8/27.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit

class LecDeviceCell: UITableViewCell {
    
    var device: LecDevice?
    var cams: [LecCam]?
    
    //灯光开关
    var light_SwitchView: LecSwitchView?
    var light_SwitchTopMargin: CGFloat = 0.0
    //灯光开关和调光
    var lightDimming_SwitchView: LecSwitchView?
    var lightDimming_SwitchTopMargin: CGFloat = 0.0
    var lightDimming_DimmingView: LecDimmingView?
    var lightDimming_DimmingTopMargin: CGFloat = 0.0
    //窗帘
    var curtain_CurtainView: LecCurtainView?
    var curtain_CurtainTopMargin: CGFloat = 0.0
    //空调
    var airConditioning_SwitchView: LecSwitchView?
    var airConditioning_SwitchTopMargin: CGFloat = 0.0
    var airConditioning_TemperatureView: LecTemperatureView?
    var airConditioning_TemperatureTopMargin: CGFloat = 0.0
    var airConditioning_SpeedView: LecSpeedView?
    var airConditioning_SpeedTopMargin: CGFloat = 0.0
    var airConditioning_ModelView: LecModelView?
    var airConditioning_ModelTopMargin: CGFloat = 0.0
    //地热
    var floorHeating_SwitchView: LecSwitchView?
    var floorHeating_SwitchTopMargin: CGFloat = 0.0
    var floorHeating_TemperatureView: LecTemperatureView?
    var floorHeating_TemperatureTopMargin: CGFloat = 0.0
    //新风
    var freshAir_SwitchView: LecSwitchView?
    var freshAir_SwitchTopMargin: CGFloat = 0.0
    var freshAir_SpeedView: LecSpeedView?
    var freshAir_SpeedTopMargin: CGFloat = 0.0

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = LecConstants.AppColor.ThemeBGColor
        selectionStyle = .default
    }
    
    convenience init(device: LecDevice, cams: [LecCam]) {
        self.init(style: .default, reuseIdentifier: LecConstants.ReuseIdentifier.DeviceCell)
        self.device = device
        self.cams = cams
        setupSubviews()
    }
    
    fileprivate func setupSubviews() {
        if let cams = self.cams, let device = self.device {
            switch device.iType {
            case .light:
                let light_SwitchCams =  cams.filter { $0.iType == 10 }
                if !light_SwitchCams.isEmpty {
                    light_SwitchView = LecSwitchView()
                    if let camView = self.light_SwitchView {
                        camView.cams = light_SwitchCams
                        if let device = self.device {
                            camView.camNameLabel.text = device.name
                        }
                        contentView.addSubview(camView)
                    }
                }
            case .lightDimming:
                let lightDimming_SwitchCams =  cams.filter { $0.iType == 20 }
                if !lightDimming_SwitchCams.isEmpty {
                    lightDimming_SwitchView = LecSwitchView()
                    lightDimming_SwitchTopMargin += 0.0
                    lightDimming_DimmingTopMargin += LecConstants.DeviceCellHeight.LightDimming_Switch
                    if let cView = self.lightDimming_SwitchView {
                        cView.cams = lightDimming_SwitchCams
                        cView.camNameLabel.text = device.name
                        contentView.addSubview(cView)
                    }
                }
                let lightDimming_DimmingCams = cams.filter { $0.iType == 21 }
                if !lightDimming_DimmingCams.isEmpty {
                    lightDimming_DimmingView = LecDimmingView()
                    if let cView = self.lightDimming_DimmingView {
                        cView.cams = lightDimming_DimmingCams
                        contentView.addSubview(cView)
                    }
                }
            case .curtain:
                let curtain_Cams = cams.filter { 30 <= $0.iType && $0.iType < 40 }
                if !curtain_Cams.isEmpty {
                    curtain_CurtainView = LecCurtainView(cams: curtain_Cams)
                    curtain_CurtainTopMargin += 0.0
                    if let cView = self.curtain_CurtainView {
                        cView.curtainNameLabel?.text = device.name
                        contentView.addSubview(cView)
                    }
                }
            case .airConditioning:
                let airConditioning_SwitchCams =  cams.filter { $0.iType == 40 }
                if !airConditioning_SwitchCams.isEmpty {
                    airConditioning_SwitchView = LecSwitchView()
                    airConditioning_SwitchTopMargin += 0.0
                    airConditioning_TemperatureTopMargin += LecConstants.DeviceCellHeight.AirConditioning_Switch
                    airConditioning_SpeedTopMargin += LecConstants.DeviceCellHeight.AirConditioning_Switch
                    airConditioning_ModelTopMargin += LecConstants.DeviceCellHeight.AirConditioning_Switch
                    if let cView = self.airConditioning_SwitchView {
                        cView.cams = airConditioning_SwitchCams
                        cView.camNameLabel.text = device.name
                        contentView.addSubview(cView)
                    }
                }
                let airConditioning_TemperatureCams = cams.filter { $0.iType == 41 }
                if !airConditioning_TemperatureCams.isEmpty {
                    airConditioning_TemperatureView = LecTemperatureView()
                    airConditioning_SpeedTopMargin += LecConstants.DeviceCellHeight.AirConditioning_Temperature
                    airConditioning_ModelTopMargin += LecConstants.DeviceCellHeight.AirConditioning_Temperature
                    if let cView = self.airConditioning_TemperatureView {
                        cView.cams = airConditioning_TemperatureCams
                        contentView.addSubview(cView)
                    }
                }
                let airConditioning_SpeedCams = cams.filter { (46...49).contains($0.iType) || (72...76).contains($0.iType) }
                if !airConditioning_SpeedCams.isEmpty {
                    airConditioning_SpeedView = LecSpeedView(cams: airConditioning_SpeedCams)
                    airConditioning_ModelTopMargin += LecConstants.DeviceCellHeight.AirConditioning_Speed
                    if let cView = self.airConditioning_SpeedView {
                        cView.cams = airConditioning_SpeedCams
                        contentView.addSubview(cView)
                    }
                }
                let airConditioning_ModelCams = cams.filter { (42...45).contains($0.iType) }
                if !airConditioning_ModelCams.isEmpty {
                    airConditioning_ModelView = LecModelView(cams: airConditioning_ModelCams)
                    if let cView = self.airConditioning_ModelView {
                        contentView.addSubview(cView)
                    }
                }
            case .floorHeating:
                let floorHeating_SwitchCams =  cams.filter { $0.iType == 50 }
                if !floorHeating_SwitchCams.isEmpty {
                    floorHeating_SwitchView = LecSwitchView()
                    floorHeating_SwitchTopMargin += 0.0
                    floorHeating_TemperatureTopMargin += LecConstants.DeviceCellHeight.FloorHeating_Switch
                    if let cView = self.floorHeating_SwitchView {
                        cView.cams = floorHeating_SwitchCams
                        cView.camNameLabel.text = device.name
                        contentView.addSubview(cView)
                    }
                }
                let floorHeating_TemperatureCams = cams.filter { $0.iType == 51 }
                if !floorHeating_TemperatureCams.isEmpty {
                    floorHeating_TemperatureView = LecTemperatureView()
                    if let cView = self.floorHeating_TemperatureView {
                        cView.cams = floorHeating_TemperatureCams
                        contentView.addSubview(cView)
                    }
                }
            case .freshAir:
                let freshAir_SwitchCams =  cams.filter { $0.iType == 60 }
                if !freshAir_SwitchCams.isEmpty {
                    freshAir_SwitchView = LecSwitchView()
                    freshAir_SwitchTopMargin += 0.0
                    freshAir_SpeedTopMargin += LecConstants.DeviceCellHeight.FreshAir_Switch
                    if let cView = self.freshAir_SwitchView {
                        cView.cams = freshAir_SwitchCams
                        cView.camNameLabel.text = device.name
                        contentView.addSubview(cView)
                    }
                }
                let freshAir_SpeedCams = cams.filter { (61...63).contains($0.iType) }
                if !freshAir_SpeedCams.isEmpty {
                    freshAir_SpeedView = LecSpeedView(cams: freshAir_SpeedCams)
                    if let cView = self.freshAir_SpeedView {
                        cView.cams = freshAir_SpeedCams
                        contentView.addSubview(cView)
                    }
                }
            default: break
            }
        }
    }
    
    //计算cell高度
    static func calculatorCellHeight(_ device: LecDevice, cams: [LecCam]) -> CGFloat {
        var height: CGFloat = 0.0
        
            switch device.iType {
            case .light:
                let light_SwitchCams =  cams.filter { $0.iType == 10 }
                if !light_SwitchCams.isEmpty {
                    height += LecConstants.DeviceCellHeight.Light_Switch
                }
            case .lightDimming:
                let lightDimming_SwitchCams =  cams.filter { $0.iType == 20 }
                if !lightDimming_SwitchCams.isEmpty {
                    height += LecConstants.DeviceCellHeight.LightDimming_Switch
                }
                let lightDimming_DimmingCams = cams.filter { $0.iType == 21 }
                if !lightDimming_DimmingCams.isEmpty {
                    height += LecConstants.DeviceCellHeight.LightDimming_Dimming
                }
            case .curtain:
                let curtain_Cams = cams.filter { 30 <= $0.iType && $0.iType < 40 }
                if !curtain_Cams.isEmpty {
                    height += LecConstants.DeviceCellHeight.Curtain_Curtain
                }
            case .airConditioning:
                let airConditioning_SwitchCams =  cams.filter { $0.iType == 40 }
                if !airConditioning_SwitchCams.isEmpty {
                    height += LecConstants.DeviceCellHeight.AirConditioning_Switch
                }
                let airConditioning_TemperatureCams = cams.filter { $0.iType == 41 }
                if !airConditioning_TemperatureCams.isEmpty {
                    height += LecConstants.DeviceCellHeight.AirConditioning_Temperature
                }
                let airConditioning_SpeedCams = cams.filter { (42...45).contains($0.iType) || (72...76).contains($0.iType)}
                if !airConditioning_SpeedCams.isEmpty {
                    height += LecConstants.DeviceCellHeight.AirConditioning_Speed
                }
                let airConditioning_ModelCams = cams.filter { (46...49).contains($0.iType) }
                if !airConditioning_ModelCams.isEmpty {
                    height += LecConstants.DeviceCellHeight.AirConditioning_Model
                }
            case .floorHeating:
                let floorHeating_SwitchCams =  cams.filter { $0.iType == 50 }
                if !floorHeating_SwitchCams.isEmpty {
                    height += LecConstants.DeviceCellHeight.FloorHeating_Switch
                }
                let floorHeating_TemperatureCams = cams.filter { $0.iType == 51 }
                if !floorHeating_TemperatureCams.isEmpty {
                    height += LecConstants.DeviceCellHeight.FloorHeating_Temperature
                }
            case .freshAir:
                let freshAir_SwitchCams =  cams.filter { $0.iType == 60 }
                if !freshAir_SwitchCams.isEmpty {
                    height += LecConstants.DeviceCellHeight.FreshAir_Switch
                }
                let freshAir_SpeedCams = cams.filter { (61...65).contains($0.iType) }
                if !freshAir_SpeedCams.isEmpty {
                    height += LecConstants.DeviceCellHeight.FreshAir_Speed
                }
            default: break
            
        }
        return height
    }
    
    fileprivate func positionCamView(_ cView: LecCamView, topMargin: CGFloat, height: CGFloat) {
        cView.autoPinEdge(toSuperviewEdge: .left)
        cView.autoPinEdge(toSuperviewEdge: .right)
        cView.autoPinEdge(toSuperviewEdge: .top, withInset: topMargin)
        cView.autoSetDimension(.height, toSize: height)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //灯光开关
        if let cView = self.light_SwitchView {
            self.positionCamView(cView, topMargin: light_SwitchTopMargin, height: LecConstants.DeviceCellHeight.Light_Switch)
        }
        
        //灯光开关和调光
        if let cView = self.lightDimming_SwitchView {
            self.positionCamView(cView, topMargin: lightDimming_SwitchTopMargin, height: LecConstants.DeviceCellHeight.LightDimming_Switch)
        }
        
        if let cView = self.lightDimming_DimmingView {
            self.positionCamView(cView, topMargin: lightDimming_DimmingTopMargin, height: LecConstants.DeviceCellHeight.LightDimming_Dimming)
        }
        
        //窗帘
        if let cView = self.curtain_CurtainView {
            self.positionCamView(cView, topMargin: curtain_CurtainTopMargin, height: LecConstants.DeviceCellHeight.Curtain_Curtain)
        }
        
        //空调
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

        //地热
        if let cView = self.floorHeating_SwitchView {
            self.positionCamView(cView, topMargin: floorHeating_SwitchTopMargin, height: LecConstants.DeviceCellHeight.FloorHeating_Switch)
        }
        
        if let cView = self.floorHeating_TemperatureView {
            self.positionCamView(cView, topMargin: floorHeating_TemperatureTopMargin, height: LecConstants.DeviceCellHeight.FloorHeating_Temperature)
        }
        
        //新风
        if let cView = self.freshAir_SwitchView {
            self.positionCamView(cView, topMargin: freshAir_SwitchTopMargin, height: LecConstants.DeviceCellHeight.FreshAir_Switch)
        }
        
        if let cView = self.freshAir_SpeedView {
            self.positionCamView(cView, topMargin: freshAir_SpeedTopMargin, height: LecConstants.DeviceCellHeight.FreshAir_Speed)
        }
    }
}
