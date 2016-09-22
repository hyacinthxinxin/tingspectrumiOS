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
    var name: String = ""
    var imageName: String = ""
}

class LecFloor: Ting {
    var floorID: String = ""
    var buildingID :String = ""
}

class LecBuilding: Ting {
    var buildingID :String = ""
    var socketAddress: String = ""
    var socketPort: UInt16 = 0
}

class LecArea: Ting {
    var areaID: String = ""
    var floorID: String = ""
}

class LecDevice: Ting {
    var deviceID: String = ""
    var areaID: String = ""
    var iType: LecDeviceType = .scene
}

class LecCam: Ting {
    var camID: String = ""
    var deviceID: String = ""
    var iType: Int = 0
    var controlType: LecCommand = .type1bit
    var controlAddress: String = ""
    var statusAddress: String = ""
    var controlValue: Int = 0
    var statusValue: Int = 0
    var minControlValue: Int = 0
    var maxControlValue: Int = 0
    var maxStatusValue: Int = 0
    var minStatusValue: Int = 0
    var usn: Int = 0
}
