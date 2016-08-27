//
//  ConfigViewController.swift
//  LeControl
//
//  Created by 新 范 on 16/8/25.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol LecConfigViewControllerDelegate: class {
    func configViewController(controller: LecConfigViewController, didChooseBuilding building: LecBuilding)
}

class LecConfigViewController: UITableViewController {
    
    weak var delegate: LecConfigViewControllerDelegate?
    var dataModel: LecDataModel!

    var userId = ""
    var buildings = [LecBuilding]()
    var floors = [LecFloor]()
    var areas = [LecArea]()
    var devices = [LecDevice]()
    var cams = [LecCam]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(userId)
        loadConfigWithUserId(userId)
    }
    
    
    func loadConfigWithUserId(userId: String) {
        Network.GETUserProjectsJSON(userId: userId).go() { [weak weakSelf = self] response in
            switch response {
            case .Success(let json):
                if let buildingsArray = json["Buildings"].array {
                    weakSelf?.buildings = parseBuilding(buildingsArray)
                    weakSelf?.tableView.reloadData()
                }
                if let floorsArray = json["Floors"].array {
                    weakSelf?.floors = parseFloor(floorsArray)
                }
                
                if let areasArray = json["Areas"].array {
                    weakSelf?.areas = parseArea(areasArray)
                }
                if let devicesArray = json["Devices"].array {
                    weakSelf?.devices = parseDevice(devicesArray)
                }
                if let camsArray = json["Cams"].array {
                    weakSelf?.cams = parseCam(camsArray)
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buildings.count
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.textLabel?.textColor = UIColor.whiteColor()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier(LecConstants.ReuseIdentifier.BuildingCell, forIndexPath: indexPath) as? LecBuildingCell {
            cell.building = buildings[indexPath.row]
            return cell
        }
        assert(false, "The dequeued table view cell was of an unknown type!")
        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        
        let building = buildings[indexPath.row]
        let buildingId = building.buildingId
        
//        let jsonBuilding = JSON(building)
//        let jsonFloors = JSON(getCurrentFloors(buildingId))
//        let jsonAreas = JSON(getCurrentAreas(buildingId))
//        let jsonDevices = JSON(getCurrentDevices(buildingId))
//        let jsonCams = JSON(getCurrentCams(buildingId))

        
        
        let currentFloors = (getCurrentFloors(buildingId)).map { $0.convertToDictionary() }
        let currentAreas = (getCurrentAreas(buildingId)).map { $0.convertToDictionary() }
        let currentDevices = (getCurrentDevices(buildingId)).map { $0.convertToDictionary() }
        let currentCams = (getCurrentCams(buildingId)).map { $0.convertToDictionary() }
        let json: JSON = ["buildingId": building.buildingId, "buildingName": building.buildingName, "socketAddress": building.socketAddress, "socketPort": Int(building.socketPort), "Floors": currentFloors, "Areas": currentAreas, "Devices": currentDevices, "Cams": currentCams]
        
        do {
            let dataBuilding = try json.rawData()
//            let dataFloors = try jsonFloors.rawData()
//            let dataAreas = try jsonAreas.rawData()
//            let dataDevices = try jsonDevices.rawData()
//            let dataCams = try jsonCams.rawData()
            
            try LecFileHelper(fileName: "CurrentProject", fileExtension: .JSON, subDirectory: "UserProject").saveFile(dataBuilding)
//            try LecFileHelper(fileName: "floors", fileExtension: .JSON, subDirectory: "UserProject").saveFile(dataFloors)
//            try LecFileHelper(fileName: "areas", fileExtension: .JSON, subDirectory: "UserProject").saveFile(dataAreas)
//            try LecFileHelper(fileName: "devices", fileExtension: .JSON, subDirectory: "UserProject").saveFile(dataDevices)
//            try LecFileHelper(fileName: "cams", fileExtension: .JSON, subDirectory: "UserProject").saveFile(dataCams)
            
            dataModel.loadData()
            delegate?.configViewController(self, didChooseBuilding: building)
        } catch {
            
        }
 
        /*
        dataModel.resetData()
        let building = buildings[indexPath.row]
        dataModel.building = building
        let buildingId = building.buildingId
        dataModel.floors = getCurrentFloors(buildingId)
        dataModel.areas = getCurrentAreas(buildingId)
        dataModel.devices = getCurrentDevices(buildingId)
        dataModel.cams = getCurrentCams(buildingId)
        */
        
    }
    
    func getCurrentFloors(buildingId: String) -> [LecFloor] {
        return floors.filter { $0.buildingId == buildingId}
    }
    
    func getCurrentAreas(buildingId: String) -> [LecArea] {
        let floors = getCurrentFloors(buildingId).map { $0.floorId }
        return areas.filter{ floors.contains($0.floorId) }
    }
    
    func getCurrentDevices(buildingId: String) -> [LecDevice] {
        let areas = getCurrentAreas(buildingId).map { $0.areaId }
        return devices.filter{ areas.contains($0.areaId) }
    }
    
    func getCurrentCams(buildingId: String) -> [LecCam] {
        let devices = getCurrentDevices(buildingId).map { $0.deviceId }
        return cams.filter{ devices.contains( $0.deviceId ) }
    }
}

