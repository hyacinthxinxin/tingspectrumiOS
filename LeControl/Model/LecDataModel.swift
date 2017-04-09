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
    
    override init() {
        super.init()
        loadData()
    }
    
    func loadData() {
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
            JDStatusBarNotification.show(withStatus: "没有找到配置项目，将在演示程序下运行", dismissAfter: 2.0, styleName: JDStatusBarStyleSuccess);
        }
    }
    
    fileprivate func parseProject(_ json: JSON) {
        if let buildingID =  json[LecConstants.LecJSONKey.ID].int{
            building.iId = buildingID
        }
        if let buildingName = json[LecConstants.LecJSONKey.BuildingName].string {
            building.name = buildingName
        }
        if let socketAddress = json[LecConstants.LecJSONKey.SocketAddress].string {
            building.socketAddress = socketAddress
        }
        
        if let socketPort = json[LecConstants.LecJSONKey.SocketPort].int {
            building.socketPort = UInt16(socketPort)
        }
        
        if let floorsArray = json[LecConstants.LecJSONKey.Floors].array {
            building.floors = floorsArray.map {
                let floor = LecFloor()
                if let buildingID = $0[LecConstants.LecJSONKey.BuildingID].int {
                    floor.sId = buildingID
                }
                if let floorID = $0[LecConstants.LecJSONKey.ID].int {
                    floor.iId = floorID
                }
                if let floorName = $0[LecConstants.LecJSONKey.FloorName].string {
                    floor.name = floorName
                }
                if let areasArray = $0[LecConstants.LecJSONKey.Areas].array {
                    floor.areas = areasArray.map {
                        let area = LecArea()
                        if let floorID = $0[LecConstants.LecJSONKey.FloorID].int {
                            area.sId = floorID
                        }
                        if let areaID = $0[LecConstants.LecJSONKey.ID].int {
                            area.iId = areaID
                        }
                        if let areaName = $0[LecConstants.LecJSONKey.AreaName].string {
                            area.name = areaName
                        }
                        if let areaImageName = $0[LecConstants.LecJSONKey.AreaImageName].string {
                            area.imageName = areaImageName
                        }
                        if let devicesArray = $0[LecConstants.LecJSONKey.Devices].array {
                            area.devices = devicesArray.map {
                                let device = LecDevice()
                                if let areaID = $0[LecConstants.LecJSONKey.AreaID].int {
                                    device.sId = areaID
                                }
                                if let deviceID = $0[LecConstants.LecJSONKey.ID].int {
                                    device.iId = deviceID
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
                                if let camsArray = $0[LecConstants.LecJSONKey.Cams].array {
                                    device.cams = camsArray.map {
                                        let cam = LecCam()
                                        if let deviceID = $0[LecConstants.LecJSONKey.DeviceID].int {
                                            cam.sId = deviceID
                                        }
                                        if let camID = $0[LecConstants.LecJSONKey.ID].int {
                                            cam.iId = camID
                                        }
                                        if let camName = $0[LecConstants.LecJSONKey.CamName].string {
                                            cam.name = camName
                                        }
                                        if let camImageName = $0[LecConstants.LecJSONKey.CamImageName].string {
                                            cam.imageName = camImageName
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
//                                            cam.statusValue = controlValue
                                        }
                                        
                                        /*
                                         if let statusValue =  $0["StatusValue"].int {
                                         cam.statusValue = statusValue
                                         }
                                         */
                                        
                                        /*
                                        if let minControlValue = $0[LecConstants.LecJSONKey.MinControlValue].int {
                                            cam.minControlValue = minControlValue
                                            cam.minStatusValue = minControlValue
                                        }
                                        
                                        if let maxControlValue = $0[LecConstants.LecJSONKey.MaxControlValue].int {
                                            cam.maxControlValue = maxControlValue
                                            cam.maxStatusValue = maxControlValue
                                        }
                                        */
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
                                return device
                            }
                        }
                        return area
                    }
                }
                return floor
            }
        }
    }
}


