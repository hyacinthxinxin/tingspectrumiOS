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
        LecSocketManager.sharedSocket.socketInfo.address = building.socketAddress
        LecSocketManager.sharedSocket.socketInfo.port = building.socketPort
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
            if let data: NSData = try LecFileHelper(fileName: "CurrentProject", fileExtension: .JSON, subDirectory: "UserProject").getContentsOfFile() {
                let json = JSON(data: data)
                parseProject(json)
            }
        } catch {
            if let filePath = NSBundle.mainBundle().pathForResource("DefaultProject", ofType: ".json"), let data = NSData(contentsOfFile: filePath) {
                let json = JSON(data: data)
                parseProject(json)
            }
        }

    }
    
    private func parseProject(json: JSON) {
        if let buildingId =  json["BuildingId"].string{
            building.buildingId = buildingId
        }
        if let buildingName = json["BuildingName"].string {
            building.buildingName = buildingName
        }
        if let socketAddress = json["IpAddress"].string {
            building.socketAddress = socketAddress
        }
        
        if let socketPort = json["IpPort"].int {
            building.socketPort = UInt16(socketPort)
        }
        
        if let floorsArray = json["Floors"].array {
            floors = parseFloor(floorsArray)
        }
        
        if let areasArray = json["Areas"].array {
            areas = parseArea(areasArray)
        }
        
        if let devicesArray = json["Devices"].array {
            devices = parseDevice(devicesArray)
        }
        
        if let camsArray = json["Cams"].array {
            cams = parseCam(camsArray)
        }
        
    }
    
    func getCamByStatusAddress(statusAddress: String) -> LecCam? {
        return cams.filter {
            $0.statusAddress == statusAddress
            }.first
    }
    
    func getCamByCamId(camId: String) -> LecCam? {
        return cams.filter {
            $0.camId == camId
            }.first
    }
}


