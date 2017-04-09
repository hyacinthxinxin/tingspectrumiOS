//
//  LecDeviceCell.swift
//  LeControl
//
//  Created by 新 范 on 16/8/27.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit

class LecDeviceCell: UITableViewCell {
    
    var device: LecDevice!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = LecConstants.AppColor.ThemeBGColor
        selectionStyle = .default
    }
    
    func positionCamView(_ cView: LecCamView, topMargin: CGFloat, height: CGFloat) {
        cView.autoPinEdge(toSuperviewEdge: .left)
        cView.autoPinEdge(toSuperviewEdge: .right)
        cView.autoPinEdge(toSuperviewEdge: .top, withInset: topMargin)
        cView.autoSetDimension(.height, toSize: height)
    }
    
    //计算cell高度
    static func calculatorCellHeight(by device: LecDevice) -> CGFloat {
        var height: CGFloat = 0.0
        if let cams = device.cams {
            switch device.iType {
            case .light:
                if !filterCams(cams, camTypes: LecConstants.DeviceCamTypes.LightSwitch).isEmpty {
                    height += LecConstants.DeviceCellHeight.Light_Switch
                }
                if !filterCams(cams, camTypes: LecConstants.DeviceCamTypes.LightDimming).isEmpty {
                    height += LecConstants.DeviceCellHeight.Light_Dimming
                }
            case .curtain:
                if !filterCams(cams, camTypes: LecConstants.DeviceCamTypes.Curtain).isEmpty {
                    height += LecConstants.DeviceCellHeight.Curtain_Curtain
                }
            case .airConditioning:
                if !filterCams(cams, camTypes: LecConstants.DeviceCamTypes.AirConditioningSwitch).isEmpty {
                    height += LecConstants.DeviceCellHeight.AirConditioning_Switch
                }
                if !filterCams(cams, camTypes: LecConstants.DeviceCamTypes.AirConditioningTemperature).isEmpty {
                    height += LecConstants.DeviceCellHeight.AirConditioning_Temperature
                }
                if !filterCams(cams, camTypes: LecConstants.DeviceCamTypes.AirConditioningSpeed).isEmpty {
                    height += LecConstants.DeviceCellHeight.AirConditioning_Speed
                }
                if !filterCams(cams, camTypes: LecConstants.DeviceCamTypes.AirConditioningModel).isEmpty {
                    height += LecConstants.DeviceCellHeight.AirConditioning_Model
                }
            case .floorHeating:
                if !filterCams(cams, camTypes: LecConstants.DeviceCamTypes.FloorHeatingSwitch).isEmpty {
                    height += LecConstants.DeviceCellHeight.FloorHeating_Switch
                }
                if !filterCams(cams, camTypes: LecConstants.DeviceCamTypes.FloorHeatingTemperature).isEmpty {
                    height += LecConstants.DeviceCellHeight.FloorHeating_Temperature
                }
            case .freshAir:
                if !filterCams(cams, camTypes: LecConstants.DeviceCamTypes.FreshAirSwitch).isEmpty {
                    height += LecConstants.DeviceCellHeight.FreshAir_Switch
                }
                if !filterCams(cams, camTypes: LecConstants.DeviceCamTypes.FreshAirSpeed).isEmpty {
                    height += LecConstants.DeviceCellHeight.FreshAir_Speed
                }
            default: break
            }
        }
        return height
    }

    static func filterCams(_ cams: [LecCam], camTypes: [Int]) -> [LecCam] {
        return cams.filter { camTypes.contains($0.iType) }
    }
    
}
