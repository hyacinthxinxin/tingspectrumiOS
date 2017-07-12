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
                                               LecDeviceType.curtain: "窗帘",
                                               LecDeviceType.airConditioning: "空调",
                                               LecDeviceType.floorHeating: "地热",
                                               LecDeviceType.freshAir: "新风",
                                               LecDeviceType.custom: "自定义"]

enum LecDeviceType: Int {
    case scene = 0
    case light = 2
    case curtain = 3
    case airConditioning = 4
    case floorHeating = 5
    case freshAir = 6
    case environment = 7
    case custom = 8
    
    var description: String{
        return deviceTypeDescriptionDictionary[self] ?? "未知的"
    }
}

class Ting: NSObject {
    var iId: Int = 0
    var sId: Int = 0
    var name: String = ""
    var imageName: String = ""
}

class LecBuilding: Ting {
    var socketAddress: String = ""
    var socketPort: UInt16 = 0
    var floors: [LecFloor]?
}

class LecFloor: Ting {
    var areas: [LecArea]?
}

class LecArea: Ting {
    var devices: [LecDevice]?
    override init() {
        super.init()
        imageName = "other"
    }
}

class LecDevice: Ting {
    var iType: LecDeviceType = .scene
    var cams: [LecCam]?
}

class LecCam: Ting {
    var iType: Int = 0
    var controlType: LecCommand = .type1bit
    var controlAddress: String = ""
    var statusAddress: String = ""
    var controlValue: Int = 0
    var isChecked = false
    
    var isSingleControl: Bool {
        get {
            return LecConstants.DeviceCamTypes.SingleControlCams.contains(iType)
        }
    }
    
    
    
    func getCamImageName(by camType: Int, isSelected: Bool) -> String {
        switch camType {
        case 30:
            return isSelected ? "open_click": "open"
        case 31:
            return isSelected ? "close_click": "close"
        case 32:
            return isSelected ? "up_click": "up"
        case 33:
            return isSelected ? "down_click": "down"
        case 34:
            return isSelected ? "pause_click": "pause"
        case 42:
            return isSelected ? "mode_heating_sel": "mode_heating"
        case 43:
            return isSelected ? "mode_refrigeration_sel": "mode_refrigeration"
        case 44:
            return isSelected ? "mode_ventilation_sel": "mode_ventilation"
        case 45:
            return isSelected ? "mode_desiccant_sel": "mode_desiccant"
        default:
            return isSelected ? "other_sel": "other"
        }
    }
    
//    var statusValue: Int = 0
//    var minControlValue: Int = 18
//    var maxControlValue: Int = 29
//    var maxStatusValue: Int = 29
//    var minStatusValue: Int = 18
//    var usn: Int = 0
}
