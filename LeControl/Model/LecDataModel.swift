//
//  LecDataModel.swift
//  LeControl
//
//  Created by 新 范 on 16/8/23.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import Foundation
import SwiftyJSON
import JDStatusBarNotification

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
            JDStatusBarNotification.show(withStatus: "没有找到配置项目，将在事例程序下运行", dismissAfter: 2.0, styleName: JDStatusBarStyleSuccess);
        }
    }
    
    fileprivate func parseProject(_ json: JSON) {
        if let buildingID =  json[LecConstants.LecJSONKey.Building, LecConstants.LecJSONKey.BuildingID].string{
            building.buildingID = buildingID
        }
        if let buildingName = json[LecConstants.LecJSONKey.Building, LecConstants.LecJSONKey.BuildingName].string {
            building.name = buildingName
        }
        if let socketAddress = json[LecConstants.LecJSONKey.Building, LecConstants.LecJSONKey.SocketAddress].string {
            building.socketAddress = socketAddress
        }
        
        if let socketPort = json[LecConstants.LecJSONKey.Building, LecConstants.LecJSONKey.SocketPort].int {
            building.socketPort = UInt16(socketPort)
        }
        
        if let floorsArray = json[LecConstants.LecJSONKey.Floors].array {
            floors = LecJsonParseHelper.parseFloor(floorsArray)
        }
        
        if let areasArray = json[LecConstants.LecJSONKey.Areas].array {
            areas = LecJsonParseHelper.parseArea(areasArray)
        }
        
        if let devicesArray = json[LecConstants.LecJSONKey.Devices].array {
            devices = LecJsonParseHelper.parseDevice(devicesArray)
        }
        
        if let camsArray = json[LecConstants.LecJSONKey.Cams].array {
            cams = LecJsonParseHelper.parseCam(camsArray)
        }
        
    }
    
    func getCamByStatusAddress(_ statusAddress: String) -> LecCam? {
        return cams.filter { $0.statusAddress == statusAddress }.first
    }
    
    func getCamByCamID(_ camID: String) -> LecCam? {
        return cams.filter { $0.camID == camID }.first
    }
    
    
}


