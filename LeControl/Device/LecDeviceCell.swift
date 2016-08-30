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
    
    var switchView: LecSwitchView?
    var dimmingView: LecDimmingView?
    var curtainNameLabel: UILabel?
    var curtainView: LecCurtainView?
    var temperatureView: LecTemperatureView?
    var speedView: LecSpeedView?
    var modelView: LecModelView?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = LecConstants.AppColor.ThemeBGColor
        selectionStyle = .None
    }
    
    convenience init(device: LecDevice, cams: [LecCam]) {
        self.init(style: .Default, reuseIdentifier: LecConstants.ReuseIdentifier.AirConditioningCell)
        self.device = device
        self.cams = cams
        setupSubviews()
    }
    
    private func setupSubviews() {
        if let cams = self.cams, let device = self.device {
            switch device.deviceType {
            case .Light:
                let switchCams =  cams.filter { $0.camType == 10 }
                if !switchCams.isEmpty {
                    switchView = LecSwitchView()
                    if let switchView = self.switchView {
                        switchView.cams = switchCams
                        if let device = self.device {
                            switchView.camNameLabel.text = device.deviceName
                        }
                        contentView.addSubview(switchView)
                    }
                }
            case .LightDimming:
                let switchCams =  cams.filter { $0.camType == 11 }
                if !switchCams.isEmpty {
                    switchView = LecSwitchView()
                    if let switchView = self.switchView {
                        switchView.cams = switchCams
                        if let device = self.device {
                            switchView.camNameLabel.text = device.deviceName
                        }
                        contentView.addSubview(switchView)
                    }
                }
                let dimmingCams = cams.filter { $0.camType == 21 }
                if !dimmingCams.isEmpty {
                    dimmingView = LecDimmingView()
                    if let dimmingView = self.dimmingView {
                        dimmingView.cams = dimmingCams
                        contentView.addSubview(dimmingView)
                    }
                }
            case .Curtain:
                curtainNameLabel = UILabel()
                if let curtainNameLabel = self.curtainNameLabel {
                    curtainNameLabel.text = device.deviceName
                    curtainNameLabel.font = UIFont.systemFontOfSize(13)
                    curtainNameLabel.textColor = UIColor.whiteColor()
                    contentView.addSubview(curtainNameLabel)
                }
                let curtainCams = cams.filter { 30 <= $0.camType && $0.camType < 40 }
                if !curtainCams.isEmpty {
                    curtainView = LecCurtainView(cams: curtainCams)
                    if let curtainView = self.curtainView {
                        contentView.addSubview(curtainView)
                    }
                }
            case .AirConditioning:
                let switchCams =  cams.filter { $0.camType == 12 }
                if !switchCams.isEmpty {
                    switchView = LecSwitchView()
                    if let switchView = self.switchView {
                        switchView.cams = switchCams
                        switchView.camNameLabel.text = device.deviceName
                        contentView.addSubview(switchView)
                    }
                }
                let temperatureCams = cams.filter { $0.camType == 22 }
                if !temperatureCams.isEmpty {
                    temperatureView = LecTemperatureView()
                    if let temperatureView = self.temperatureView {
                        temperatureView.cams = temperatureCams
                        contentView.addSubview(temperatureView)
                    }
                }
                let speedCams = cams.filter { (40...44).contains($0.camType) }
                if !speedCams.isEmpty {
                    speedView = LecSpeedView(cams: speedCams)
                    if let speedView = self.speedView {
                        speedView.cams = speedCams
                        contentView.addSubview(speedView)
                    }
                }
                let modelCams = cams.filter { (50...53).contains($0.camType) }
                if !modelCams.isEmpty {
                    modelView = LecModelView(cams: modelCams)
                    if let modelView = self.modelView {
                        contentView.addSubview(modelView)
                    }
                }
            case .FloorHeating:
                let switchCams =  cams.filter { $0.camType == 13 }
                if !switchCams.isEmpty {
                    switchView = LecSwitchView()
                    if let switchView = self.switchView {
                        switchView.cams = switchCams
                        if let device = self.device {
                            switchView.camNameLabel.text = device.deviceName
                        }
                        contentView.addSubview(switchView)
                    }
                }
                let temperatureCams = cams.filter { $0.camType == 23 }
                if !temperatureCams.isEmpty {
                    temperatureView = LecTemperatureView()
                    if let temperatureView = self.temperatureView {
                        temperatureView.cams = temperatureCams
                        contentView.addSubview(temperatureView)
                    }
                }
            case .FreshAir:
                let switchCams =  cams.filter { $0.camType == 14 }
                if !switchCams.isEmpty {
                    switchView = LecSwitchView()
                    if let switchView = self.switchView {
                        switchView.cams = switchCams
                        if let device = self.device {
                            switchView.camNameLabel.text = device.deviceName
                        }
                        contentView.addSubview(switchView)
                    }
                }
                let speedCams = cams.filter { (45...49).contains($0.camType) }
                if !speedCams.isEmpty {
                    speedView = LecSpeedView(cams: speedCams)
                    if let speedView = self.speedView {
                        speedView.cams = speedCams
                        contentView.addSubview(speedView)
                    }
                }
            default: break
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let switchView = self.switchView {
            switchView.autoPinEdgeToSuperviewEdge(.Left)
            switchView.autoPinEdgeToSuperviewEdge(.Right)
            switchView.autoPinEdgeToSuperviewEdge(.Top)
            switchView.autoSetDimension(.Height, toSize: LecConstants.DeviceCellHeight.Switch)
        }
        
        if let dimmingView = self.dimmingView {
            dimmingView.autoPinEdgeToSuperviewEdge(.Left)
            dimmingView.autoPinEdgeToSuperviewEdge(.Right)
            dimmingView.autoPinEdgeToSuperviewEdge(.Top, withInset: LecConstants.DeviceCellHeight.Switch)
            dimmingView.autoSetDimension(.Height, toSize: LecConstants.DeviceCellHeight.Dimming)
        }
        
        if let curtainNameLabel = self.curtainNameLabel {
            curtainNameLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 14)
            curtainNameLabel.autoPinEdgeToSuperviewEdge(.Top, withInset: 10)
            if let curtainView = self.curtainView {
                curtainView.autoPinEdgeToSuperviewEdge(.Left)
                curtainView.autoPinEdgeToSuperviewEdge(.Right)
                curtainView.autoPinEdgeToSuperviewEdge(.Bottom)
                curtainView.autoPinEdge(.Top, toEdge: .Bottom, ofView: curtainNameLabel)
            }
        }
        
        if let temperatureView = self.temperatureView {
            temperatureView.autoPinEdgeToSuperviewEdge(.Left)
            temperatureView.autoPinEdgeToSuperviewEdge(.Right)
            temperatureView.autoPinEdgeToSuperviewEdge(.Top, withInset: LecConstants.DeviceCellHeight.Switch)
            temperatureView.autoSetDimension(.Height, toSize: LecConstants.DeviceCellHeight.Temperature)
        }
        
        if let speedView = self.speedView {
            speedView.autoPinEdgeToSuperviewEdge(.Left)
            speedView.autoPinEdgeToSuperviewEdge(.Right)
            speedView.autoPinEdgeToSuperviewEdge(.Top, withInset: LecConstants.DeviceCellHeight.Switch + LecConstants.DeviceCellHeight.Temperature)
            speedView.autoSetDimension(.Height, toSize: LecConstants.DeviceCellHeight.Speed)
        }
        
        if let modelView = self.modelView {
            modelView.autoPinEdgeToSuperviewEdge(.Left)
            modelView.autoPinEdgeToSuperviewEdge(.Right)
            modelView.autoPinEdgeToSuperviewEdge(.Top, withInset: LecConstants.DeviceCellHeight.Switch + LecConstants.DeviceCellHeight.Temperature + LecConstants.DeviceCellHeight.Speed)
            modelView.autoSetDimension(.Height, toSize: LecConstants.DeviceCellHeight.Model)
        }
    }
}
