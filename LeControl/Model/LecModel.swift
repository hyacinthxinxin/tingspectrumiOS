//
//  LecModel.swift
//  LeControl
//
//  Created by 新 范 on 16/8/23.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import Foundation

enum LecCommand: Int {
    case type1bit = 0x00
    case type1byte = 0x01
    case type2byte = 0x02
}

private let deviceTypeDescriptionDictionary = [LecDeviceType.scene: "场景",
                                               LecDeviceType.light: "灯光开关",
                                               LecDeviceType.lightDimming: "灯光调光",
                                               LecDeviceType.curtain: "窗帘",
                                               LecDeviceType.airConditioning: "空调",
                                               LecDeviceType.floorHeating: "地热",
                                               LecDeviceType.freshAir: "新风",
                                               LecDeviceType.custom: "自定义"]

enum LecDeviceType: Int {
    case scene = 0
    case light
    case lightDimming
    case curtain
    case airConditioning
    case floorHeating
    case freshAir
    case custom
    
    var description: String{
        return deviceTypeDescriptionDictionary[self] ?? "未知的"
    }
}

class Ting: NSObject {
    var sID: String = ""
    var iID: String = ""
    var name: String = ""
    var imageName: String = ""
}

class LecBuilding: Ting {
    var buildingId :String = ""
    var buildingName = ""
    var buildingImageName = ""
    var socketAddress: String = ""
    var socketPort: UInt16 = 0
}

class LecFloor: Ting {
    var floorId: String = ""
    var buildingId :String = ""
    var floorName: String = ""
    var floorImageName: String = ""
    func convertToDictionary() -> [String: AnyObject] {
        return [LecConstants.LecJSONKey.FloorId: floorId as AnyObject,
                LecConstants.LecJSONKey.BuildingId: buildingId as AnyObject,
                LecConstants.LecJSONKey.FloorName: floorName as AnyObject,
                LecConstants.LecJSONKey.FloorImageName: floorImageName as AnyObject]
    }
}

class LecArea: Ting {
//    private let areaImageNames = ["living_room", "dining_room", "main_bedroom", "study_room", "childrem_room", "video_room"];
    
    var areaId: String = ""
    var floorId: String = ""
    var areaName: String = ""
    var areaImageName: String = ""
    
//    override init() {
//        areaImageName = areaImageNames[Int(arc4random_uniform(5))]
//    }
    
    func convertToDictionary() -> [String: AnyObject] {
        return [LecConstants.LecJSONKey.AreaId: areaId as AnyObject,
                LecConstants.LecJSONKey.FloorId: floorId as AnyObject,
                LecConstants.LecJSONKey.AreaName: areaName as AnyObject,
                LecConstants.LecJSONKey.AreaImageName: areaImageName as AnyObject
        ]
    }
}

class LecDevice: Ting {
    var deviceId: String = ""
    var areaId: String = ""
    var deviceType: LecDeviceType = .scene
    var deviceName: String = ""
    var deviceImageName: String = ""
    func convertToDictionary() -> [String: AnyObject] {
        return [LecConstants.LecJSONKey.DeviceId: deviceId as AnyObject,
                LecConstants.LecJSONKey.AreaId: areaId as AnyObject,
                LecConstants.LecJSONKey.DeviceType: deviceType.rawValue as AnyObject,
                LecConstants.LecJSONKey.DeviceName: deviceName as AnyObject,
                LecConstants.LecJSONKey.DeviceImageName: deviceImageName as AnyObject
        ]
    }
}

class LecCam: Ting {
    var camId: String = ""
    var deviceId: String = ""
    var camName: String = ""
    var camImageName: String = ""
    var camType: Int = 0
    var commandType: LecCommand = .type1bit
    var controlAddress: String = ""
    var statusAddress: String = ""
    var controlValue: Int = 0
    var statusValue: Int = 0
    var minControlValue = 0
    var maxControlValue = 0
    var maxStatusValue = 0
    var minStatusValue = 0
    var usn = 0

    func updateStatusValue(_ statusValue: Int) {
        self.statusValue = statusValue
    }
    
    func convertToDictionary() -> [String: AnyObject] {
        return [LecConstants.LecJSONKey.CamId: camId as AnyObject,
                LecConstants.LecJSONKey.DeviceId: deviceId as AnyObject,
                LecConstants.LecJSONKey.CamName: camName as AnyObject,
                LecConstants.LecJSONKey.CamImageName: camImageName as AnyObject,
                LecConstants.LecJSONKey.CamType: camType as AnyObject,
                LecConstants.LecJSONKey.CommandType: commandType.rawValue as AnyObject,
                LecConstants.LecJSONKey.ControlAddress: controlAddress as AnyObject,
                LecConstants.LecJSONKey.StatusAddress: statusAddress as AnyObject,
                LecConstants.LecJSONKey.ControlValue: controlValue as Int as AnyObject,
                LecConstants.LecJSONKey.StatusValue: statusValue as AnyObject,
                LecConstants.LecJSONKey.MinControlValue: minControlValue as AnyObject,
                LecConstants.LecJSONKey.MaxControlValue: maxControlValue as AnyObject,
                LecConstants.LecJSONKey.MinStatusValue: minStatusValue as AnyObject,
                LecConstants.LecJSONKey.MaxStatusValue: maxStatusValue as AnyObject,
                LecConstants.LecJSONKey.Usn: usn as AnyObject
        ]
    }
}
