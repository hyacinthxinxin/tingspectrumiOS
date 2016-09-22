//
//  LecJsonParseHelper.swift
//  LeControl
//
//  Created by 新 范 on 16/8/25.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import Foundation
import SwiftyJSON

class LecJsonParseHelper {
    
 static func parseBuilding(_ jsons: [JSON]) -> [LecBuilding] {
    return jsons.map {
        let building = LecBuilding()
        if let buildingID =  $0[LecConstants.LecJSONKey.BuildingID].string{
            building.buildingID = buildingID
        }
        if let buildingName = $0[LecConstants.LecJSONKey.BuildingName].string {
            building.name = buildingName
        }
        if let socketAddress = $0[LecConstants.LecJSONKey.SocketAddress].string {
            building.socketAddress = socketAddress
        }
        
        if let socketPort = $0[LecConstants.LecJSONKey.SocketPort].int {
            building.socketPort = UInt16(socketPort)
        }
        return building
    }
}

static func parseFloor(_ jsons: [JSON]) -> [LecFloor] {
    return jsons.map {
        let floor = LecFloor()
        if let buildingID = $0[LecConstants.LecJSONKey.BuildingID].string {
            floor.buildingID = buildingID
        }
        if let floorID = $0[LecConstants.LecJSONKey.FloorID].string {
            floor.floorID = floorID
        }
        if let floorName = $0[LecConstants.LecJSONKey.FloorName].string {
            floor.name = floorName
        }
        return floor
    }
}

static func parseArea(_ jsons: [JSON]) -> [LecArea] {
    return jsons.map {
        let area = LecArea()
        if let floorID = $0[LecConstants.LecJSONKey.FloorID].string {
            area.floorID = floorID
        }
        if let areaID = $0[LecConstants.LecJSONKey.AreaID].string {
            area.areaID = areaID
        }
        if let areaName = $0[LecConstants.LecJSONKey.AreaName].string {
            area.name = areaName
        }
        if let areaImageName = $0[LecConstants.LecJSONKey.AreaImageName].string {
            area.imageName = areaImageName
        }
        return area
    }
    
}

static func parseDevice(_ jsons: [JSON]) -> [LecDevice] {
    return jsons.map {
        let device = LecDevice()
        if let areaID = $0[LecConstants.LecJSONKey.AreaID].string {
            device.areaID = areaID
        }
        if let deviceID = $0[LecConstants.LecJSONKey.DeviceID].string {
            device.deviceID = deviceID
        }
        if let deviceName = $0[LecConstants.LecJSONKey.DeviceName].string {
            device.name = deviceName
        }
        if let deviceImageName = $0[LecConstants.LecJSONKey.DeviceImageName].string {
            device.imageName = deviceImageName
        }
        if let deviceType = $0[LecConstants.LecJSONKey.DeviceType].int {
            if let type = LecDeviceType(rawValue: deviceType) {
                device.iType = type
            }
        }
        return device
    }
}

    static func parseCam(_ jsons: [JSON]) -> [LecCam] {
    return jsons.map {
        let cam = LecCam()
        if let deviceID = $0[LecConstants.LecJSONKey.DeviceID].string {
            cam.deviceID = deviceID
        }
        if let camID = $0[LecConstants.LecJSONKey.CamID].string {
            cam.camID = camID
        }
        if let camName = $0[LecConstants.LecJSONKey.CamName].string {
            cam.name = camName
        }
        
        if let camType = $0[LecConstants.LecJSONKey.CamType].int {
            cam.iType = camType
        }
        
        if let rawControlType = $0[LecConstants.LecJSONKey.ControlType].int, let controlType = LecCommand(rawValue: rawControlType) {
            cam.controlType = controlType
        }
        
        if let controlAddress = $0[LecConstants.LecJSONKey.ControlAddress].string {
            cam.controlAddress = controlAddress
        }
        
        if let statusAddress = $0[LecConstants.LecJSONKey.StatusAddress].string {
            cam.statusAddress = statusAddress
        }
        
        if let controlValue = $0[LecConstants.LecJSONKey.ControlValue].int {
            cam.controlValue = controlValue
            cam.statusValue = controlValue
        }
        
        /*
        if let statusValue =  $0["StatusValue"].int {
            cam.statusValue = statusValue
        }
*/
        
        if let minControlValue = $0[LecConstants.LecJSONKey.MinControlValue].int {
            cam.minControlValue = minControlValue
            cam.minStatusValue = minControlValue
        }
        
        if let maxControlValue = $0[LecConstants.LecJSONKey.MaxControlValue].int {
            cam.maxControlValue = maxControlValue
            cam.maxStatusValue = maxControlValue
        }
        
        /*
        if let minStatusValue = $0[LecConstants.LecJSONKey.MinStatusValue].int {
            cam.minStatusValue = minStatusValue
        }
        
        if let maxStatusValue = $0[LecConstants.LecJSONKey.MaxStatusValue].int {
            cam.maxStatusValue = maxStatusValue
        }
*/
        
        return cam
    }
}
}
