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

    var userId = ""
    var buildings = [LecBuilding]()
    var floors = [LecFloor]()
    var areas = [LecArea]()
    var devices = [LecDevice]()
    var cams = [LecCam]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        tableView.backgroundColor = UIColor(white: 0.5, alpha: 0.2)
        tableView.separatorColor = UIColor(white: 1, alpha: 0.07)
        //        if #available(iOS 9, *) {
        tableView.cellLayoutMarginsFollowReadableWidth = false
        //        }

        loadConfigWithUserId(userId)
    }
    
    
    func loadConfigWithUserId(userId: String) {
        Network.GETUserProjectsJSON(userId: userId).go() { [weak weakSelf = self] response in
            switch response {
            case .Success(let json):
                if let buildingsArray = json[LecConstants.LecJSONKey.Buildings].array {
                    weakSelf?.buildings = parseBuilding(buildingsArray)
                    weakSelf?.tableView.reloadData()
                }
                if let floorsArray = json[LecConstants.LecJSONKey.Floors].array {
                    weakSelf?.floors = parseFloor(floorsArray)
                }
                
                if let areasArray = json[LecConstants.LecJSONKey.Areas].array {
                    weakSelf?.areas = parseArea(areasArray)
                }
                if let devicesArray = json[LecConstants.LecJSONKey.Devices].array {
                    weakSelf?.devices = parseDevice(devicesArray)
                }
                if let camsArray = json[LecConstants.LecJSONKey.Cams].array {
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
        cell.backgroundColor = UIColor.clearColor()
        cell.contentView.backgroundColor = UIColor.clearColor()
        cell.textLabel?.textColor = UIColor.whiteColor()

        if cell.respondsToSelector(Selector("setSeparatorInset:")){
            cell.separatorInset = UIEdgeInsetsZero
        }
        if cell.respondsToSelector(Selector("setPreservesSuperviewLayoutMargins:")) {
            cell.preservesSuperviewLayoutMargins = false
        }
        if cell.respondsToSelector(Selector("setLayoutMargins:")){
            cell.layoutMargins = UIEdgeInsetsZero
        }
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
        let currentFloors = (getCurrentFloors(buildingId)).map { $0.convertToDictionary() }
        let currentAreas = (getCurrentAreas(buildingId)).map { $0.convertToDictionary() }
        let currentDevices = (getCurrentDevices(buildingId)).map { $0.convertToDictionary() }
        let currentCams = (getCurrentCams(buildingId)).map { $0.convertToDictionary() }
        let json: JSON = [LecConstants.LecJSONKey.BuildingId: building.buildingId,
                          LecConstants.LecJSONKey.BuildingName: building.buildingName,
                          LecConstants.LecJSONKey.IpAddress: building.socketAddress,
                          LecConstants.LecJSONKey.IpPort: Int(building.socketPort),
                          LecConstants.LecJSONKey.Floors: currentFloors,
                          LecConstants.LecJSONKey.Areas: currentAreas,
                          LecConstants.LecJSONKey.Devices: currentDevices,
                          LecConstants.LecJSONKey.Cams: currentCams]
        
        do {
            let dataBuilding = try json.rawData()
            try LecFileHelper(fileName: "CurrentProject", fileExtension: .JSON, subDirectory: "UserProject").saveFile(dataBuilding)
            LecSocketManager.sharedSocket.dataModel.loadData()
            delegate?.configViewController(self, didChooseBuilding: building)
        } catch {
            
        }
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

