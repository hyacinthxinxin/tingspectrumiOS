//
//  LecDataModel.swift
//  LeControl
//
//  Created by 新 范 on 16/8/23.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import Foundation
import SwiftyJSON

class LecDataModel: NSObject {
    var building = LecBuilding()
    var floors = [LecFloor]()
    var areas = [LecArea]()
    var devices = [LecDevice]()
    var cams = [LecCam]()
    
    override init() {
        super.init()
        loadData()
    }
    
    func resetData() {
        floors.removeAll()
        areas.removeAll()
        devices.removeAll()
        cams.removeAll()
    }
    
    func loadData() {
        resetData()
        do {
            if let data: Data = try LecFileHelper(fileName: "CurrentProject", fileExtension: .JSON, subDirectory: "UserProject").getContentsOfFile() {
                let json = JSON(data: data)
                parseProject(json)
            }
        } catch {
            if let filePath = Bundle.main.path(forResource: "DefaultProject", ofType: ".json"), let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) {
                let json = JSON(data: data)
                parseProject(json)
            }
        }

    }
    
    fileprivate func parseProject(_ json: JSON) {
        if let buildingId =  json[LecConstants.LecJSONKey.BuildingId].string{
            building.buildingId = buildingId
        }
        if let buildingName = json[LecConstants.LecJSONKey.BuildingName].string {
            building.buildingName = buildingName
        }
        if let socketAddress = json[LecConstants.LecJSONKey.IpAddress].string {
            building.socketAddress = socketAddress
        }
        
        if let socketPort = json[LecConstants.LecJSONKey.IpPort].int {
            building.socketPort = UInt16(socketPort)
        }
        
        if let floorsArray = json[LecConstants.LecJSONKey.Floors].array {
            floors = parseFloor(floorsArray)
        }
        
        if let areasArray = json[LecConstants.LecJSONKey.Areas].array {
            areas = parseArea(areasArray)
        }
        
        if let devicesArray = json[LecConstants.LecJSONKey.Devices].array {
            devices = parseDevice(devicesArray)
        }
        
        if let camsArray = json[LecConstants.LecJSONKey.Cams].array {
            cams = parseCam(camsArray)
        }
        
    }
    
    func getCamByStatusAddress(_ statusAddress: String) -> LecCam? {
        return cams.filter { $0.statusAddress == statusAddress }.first
    }
    
    func getCamByCamId(_ camId: String) -> LecCam? {
        return cams.filter { $0.camId == camId }.first
    }
}


