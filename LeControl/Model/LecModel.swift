//
//  LecModel.swift
//  LeControl
//
//  Created by 新 范 on 16/8/23.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import Foundation

enum LecCommand: Int {
    case Type1bit = 0x00
    case Type1byte = 0x01
    case Type2byte = 0x02
}

private let deviceTypeDescriptionDictionary = [LecDeviceType.Scene: "场景",
                                               LecDeviceType.Light: "灯光开关",
                                               LecDeviceType.LightDimming: "灯光调光",
                                               LecDeviceType.Curtain: "窗帘",
                                               LecDeviceType.AirConditioning: "空调",
                                               LecDeviceType.FloorHeating: "地热",
                                               LecDeviceType.FreshAir: "新风",
                                               LecDeviceType.Custom: "自定义"]

enum LecDeviceType: Int {
    case Scene = 0
    case Light
    case LightDimming
    case Curtain
    case AirConditioning
    case FloorHeating
    case FreshAir
    case Custom
    
    var description: String{
        return deviceTypeDescriptionDictionary[self] ?? "未知的"
    }
}

class LecBuilding: NSObject {
    var socketAddress: String = ""
    var socketPort: UInt16 = 0
    var buildingId :String = ""
    var buildingName = ""
}

class LecFloor: NSObject {
    var buildingId :String = ""
    var floorId: String = ""
    var floorName: String = ""
    
    func convertToDictionary() -> [String: AnyObject] {
        return [LecConstants.JSONKey.BuildingId: buildingId,
                LecConstants.JSONKey.FloorId: floorId,
                LecConstants.JSONKey.FloorName: floorName]
    }
}

class LecArea: NSObject {
    private let areaImageNames = ["living_room", "dining_room", "main_bedroom", "study_room", "childrem_room", "video_room"];
    
    var floorId: String = ""
    var areaId: String = ""
    var areaName: String = ""
    var areaImageName: String = ""
    
    override init() {
        areaImageName = areaImageNames[Int(arc4random_uniform(5))]
    }
    
    func convertToDictionary() -> [String: AnyObject] {
        return [LecConstants.JSONKey.FloorId: floorId,
                LecConstants.JSONKey.AreaId: areaId,
                LecConstants.JSONKey.AreaName: areaName,
                LecConstants.JSONKey.AreaImageName: areaImageName
        ]
    }
}

class LecDevice: NSObject {
    var areaId: String = ""
    var deviceId: String = ""
    var deviceType: LecDeviceType = .Scene
    var deviceName: String = ""
    
    func convertToDictionary() -> [String: AnyObject] {
        return [LecConstants.JSONKey.AreaId: areaId,
                LecConstants.JSONKey.DeviceId: deviceId,
                LecConstants.JSONKey.DeviceType: deviceType.rawValue,
                LecConstants.JSONKey.DeviceName:deviceName
        ]
    }
}

enum LecSubCamType: Int {
    case Swicth = 0
    case Dimming
    case Temperature
    case Speed
    case Model
}

class LecCam: NSObject {
    var deviceId: String = ""
    var camId: String = ""
    var camName: String = ""
    var camImageName: String = ""
    var subCamType: LecSubCamType = .Speed
    var commandType: LecCommand = .Type1bit
    var controlAddress: String = ""
    var statusAddress: String = ""
    var controlValue: Int = 0
    var statusValue: Int = 0
    var isVisible: Bool = false
    var minControlValue = 0
    var maxControlValue = 0
    var maxStatusValue = 0
    var minStatusValue = 0
    var usn = 0

    func updateStatusValue(statusValue: Int) {
        self.statusValue = statusValue
    }
    
    static let CamId = "CamId"
    static let CamType = "CamType"
    static let SubCamType = "SubCamType"
    static let CamName = "CamName"
    static let ControlType = "ControlType"
    static let ControlAddress = "ControlAddress"
    static let StatusAddress = "StatusAddress"
    static let ControlValue = "ControlValue"
    static let MinControlValue = "MinControlValue"
    static let MaxControlValue = "MaxControlValue"
    static let StatusValue = "StatusValue"
    static let MaxStatusValue = "MaxStatusValue"
    static let MinStatusValue = "MinStatusValue"
    static let Usn = "Usn"
    
    func convertToDictionary() -> [String: AnyObject] {
        return [LecConstants.JSONKey.DeviceId: deviceId,
                LecConstants.JSONKey.CamId: camId,
                LecConstants.JSONKey.CamName: camName,
                LecConstants.JSONKey.SubCamType: subCamType.rawValue,
                LecConstants.JSONKey.ControlType: commandType.rawValue,
                LecConstants.JSONKey.ControlAddress: controlAddress,
                LecConstants.JSONKey.StatusAddress: statusAddress,
                LecConstants.JSONKey.ControlValue: controlValue,
                LecConstants.JSONKey.StatusValue: statusValue,
                LecConstants.JSONKey.MinControlValue: minControlValue,
                LecConstants.JSONKey.MaxControlValue: maxControlValue,
                LecConstants.JSONKey.MinStatusValue: minStatusValue,
                LecConstants.JSONKey.MaxStatusValue: maxStatusValue,
                LecConstants.JSONKey.Usn: usn,
        ]
    }
}