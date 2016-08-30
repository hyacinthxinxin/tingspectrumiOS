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
    var buildingId :String = ""
    var buildingName = ""
    var buildingImageName = ""
    var socketAddress: String = ""
    var socketPort: UInt16 = 0
}

class LecFloor: NSObject {
    var floorId: String = ""
    var buildingId :String = ""
    var floorName: String = ""
    var floorImageName: String = ""
    func convertToDictionary() -> [String: AnyObject] {
        return [LecConstants.LecJSONKey.FloorId: floorId,
                LecConstants.LecJSONKey.BuildingId: buildingId,
                LecConstants.LecJSONKey.FloorName: floorName,
                LecConstants.LecJSONKey.FloorImageName: floorImageName]
    }
}

class LecArea: NSObject {
//    private let areaImageNames = ["living_room", "dining_room", "main_bedroom", "study_room", "childrem_room", "video_room"];
    
    var areaId: String = ""
    var floorId: String = ""
    var areaName: String = ""
    var areaImageName: String = ""
    
//    override init() {
//        areaImageName = areaImageNames[Int(arc4random_uniform(5))]
//    }
    
    func convertToDictionary() -> [String: AnyObject] {
        return [LecConstants.LecJSONKey.AreaId: areaId,
                LecConstants.LecJSONKey.FloorId: floorId,
                LecConstants.LecJSONKey.AreaName: areaName,
                LecConstants.LecJSONKey.AreaImageName: areaImageName
        ]
    }
}

class LecDevice: NSObject {
    var deviceId: String = ""
    var areaId: String = ""
    var deviceType: LecDeviceType = .Scene
    var deviceName: String = ""
    var deviceImageName: String = ""
    func convertToDictionary() -> [String: AnyObject] {
        return [LecConstants.LecJSONKey.DeviceId: deviceId,
                LecConstants.LecJSONKey.AreaId: areaId,
                LecConstants.LecJSONKey.DeviceType: deviceType.rawValue,
                LecConstants.LecJSONKey.DeviceName: deviceName,
                LecConstants.LecJSONKey.DeviceImageName: deviceImageName
        ]
    }
}

class LecCam: NSObject {
    var camId: String = ""
    var deviceId: String = ""
    var camName: String = ""
    var camImageName: String = ""
    var camType: Int = 0
    var commandType: LecCommand = .Type1bit
    var controlAddress: String = ""
    var statusAddress: String = ""
    var controlValue: Int = 0
    var statusValue: Int = 0
    var minControlValue = 0
    var maxControlValue = 0
    var maxStatusValue = 0
    var minStatusValue = 0
    var usn = 0

    func updateStatusValue(statusValue: Int) {
        self.statusValue = statusValue
    }
    
    func convertToDictionary() -> [String: AnyObject] {
        return [LecConstants.LecJSONKey.CamId: camId,
                LecConstants.LecJSONKey.DeviceId: deviceId,
                LecConstants.LecJSONKey.CamName: camName,
                LecConstants.LecJSONKey.CamImageName: camImageName,
                LecConstants.LecJSONKey.CamType: camType,
                LecConstants.LecJSONKey.CommandType: commandType.rawValue,
                LecConstants.LecJSONKey.ControlAddress: controlAddress,
                LecConstants.LecJSONKey.StatusAddress: statusAddress,
                LecConstants.LecJSONKey.ControlValue: controlValue,
                LecConstants.LecJSONKey.StatusValue: statusValue,
                LecConstants.LecJSONKey.MinControlValue: minControlValue,
                LecConstants.LecJSONKey.MaxControlValue: maxControlValue,
                LecConstants.LecJSONKey.MinStatusValue: minStatusValue,
                LecConstants.LecJSONKey.MaxStatusValue: maxStatusValue,
                LecConstants.LecJSONKey.Usn: usn
        ]
    }
}