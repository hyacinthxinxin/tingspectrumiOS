//
//  LecJsonParseHelper.swift
//  LeControl
//
//  Created by 新 范 on 16/8/25.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import Foundation
import SwiftyJSON

func parseBuilding(jsons: [JSON]) -> [LecBuilding] {
    return jsons.map {
        let building = LecBuilding()
        if let buildingId =  $0[LecConstants.LecJSONKey.BuildingId].string{
            building.buildingId = buildingId
        }
        if let buildingName = $0[LecConstants.LecJSONKey.BuildingName].string {
            building.buildingName = buildingName
        }
        if let socketAddress = $0[LecConstants.LecJSONKey.IpAddress].string {
            building.socketAddress = socketAddress
        }
        
        if let socketPort = $0[LecConstants.LecJSONKey.IpPort].int {
            building.socketPort = UInt16(socketPort)
        }
        return building
    }
}

func parseFloor(jsons: [JSON]) -> [LecFloor] {
    return jsons.map {
        let floor = LecFloor()
        if let buildingId = $0[LecConstants.LecJSONKey.BuildingId].string {
            floor.buildingId = buildingId
        }
        if let floorId = $0[LecConstants.LecJSONKey.FloorId].string {
            floor.floorId = floorId
        }
        if let floorName = $0[LecConstants.LecJSONKey.FloorName].string {
            floor.floorName = floorName
        }
        return floor
    }
}

func parseArea(jsons: [JSON]) -> [LecArea] {
    return jsons.map {
        let area = LecArea()
        if let floorId = $0[LecConstants.LecJSONKey.FloorId].string {
            area.floorId = floorId
        }
        if let areaId = $0[LecConstants.LecJSONKey.AreaId].string {
            area.areaId = areaId
        }
        if let areaName = $0[LecConstants.LecJSONKey.AreaName].string {
            area.areaName = areaName
        }
        return area
    }
    
}

func parseDevice(jsons: [JSON]) -> [LecDevice] {
    return jsons.map {
        let device = LecDevice()
        if let areaId = $0[LecConstants.LecJSONKey.AreaId].string {
            device.areaId = areaId
        }
        if let deviceId = $0[LecConstants.LecJSONKey.DeviceId].string {
            device.deviceId = deviceId
        }
        if let deviceName = $0[LecConstants.LecJSONKey.DeviceName].string {
            device.deviceName = deviceName
        }
        if let deviceType = $0[LecConstants.LecJSONKey.DeviceType].int {
            if let type = LecDeviceType(rawValue: deviceType) {
                device.deviceType = type
            }
        }
        return device
    }
}

func parseCam(jsons: [JSON]) -> [LecCam] {
    return jsons.map {
        let cam = LecCam()
        if let deviceId = $0[LecConstants.LecJSONKey.DeviceId].string {
            cam.deviceId = deviceId
        }
        if let camId = $0[LecConstants.LecJSONKey.CamId].string {
            cam.camId = camId
        }
        if let camName = $0[LecConstants.LecJSONKey.CamName].string {
            cam.camName = camName
        }
        
        if let camType = $0[LecConstants.LecJSONKey.CamType].int {
            cam.camType = camType
        }
        
        if let rawCommandType = $0[LecConstants.LecJSONKey.CommandType].int, commandType = LecCommand(rawValue: rawCommandType) {
            cam.commandType = commandType
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
        }*/
        
        if let isVisible = $0[LecConstants.LecJSONKey.IsVisible].bool {
            cam.isVisible = isVisible
        }
        
        if let minControlValue = $0[LecConstants.LecJSONKey.MinControlValue].int {
            cam.minControlValue = minControlValue

        }
        if let maxControlValue = $0[LecConstants.LecJSONKey.MaxControlValue].int {
            cam.maxControlValue = maxControlValue
            
        }
        if let maxStatusValue = $0[LecConstants.LecJSONKey.MaxStatusValue].int {
            cam.maxStatusValue = maxStatusValue
        }
        if let minStatusValue = $0[LecConstants.LecJSONKey.MinStatusValue].int {
            cam.minStatusValue = minStatusValue
        }
        return cam
    }
}

