//
//  ConfigViewController.swift
//  LeControl
//
//  Created by 新 范 on 16/8/25.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import JDStatusBarNotification

protocol LecConfigViewControllerDelegate: class {
    func configViewController(_ controller: LecConfigViewController, didChooseBuilding building: LecBuilding)
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

        loadConfig(with: userId);
    }
    
    
    func loadConfig(with userID: String) {
        print(userID)
        let loginUrl = environment.httpAddress + LecConstants.NetworkSubAddress.Buildings
        Alamofire.request(loginUrl, method: .get, parameters: ["sID":userID]).responseJSON(completionHandler: { [weak weakSelf = self] (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let buildingsArray = json.array {
                    weakSelf?.buildings = buildingsArray.map {
                        let building = LecBuilding()
                        if let iID = $0["iID"].string {
                            building.iID = iID
                        }
                        if let name = $0["name"].string {
                            building.name = name
                        }
                        return building
                    }
                    weakSelf?.tableView.reloadData()
                }
            case .failure:
                JDStatusBarNotification.show(withStatus: "登录失败", dismissAfter: 2.0, styleName: JDStatusBarStyleSuccess);
            }})
        /*
        Network.getUserProjectsJSON(userId: userId).go() { [weak weakSelf = self] response in
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
            case .failure(let error):
                print(error)
            }
        }
 */
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buildings.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = UIColor.white

        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)){
            cell.separatorInset = UIEdgeInsets.zero
        }
        if cell.responds(to: #selector(setter: UIView.preservesSuperviewLayoutMargins)) {
            cell.preservesSuperviewLayoutMargins = false
        }
        if cell.responds(to: #selector(setter: UIView.layoutMargins)){
            cell.layoutMargins = UIEdgeInsets.zero
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: LecConstants.ReuseIdentifier.BuildingCell, for: indexPath) as? LecBuildingCell {
            cell.building = buildings[(indexPath as NSIndexPath).row]
            return cell
        }
        assert(false, "The dequeued table view cell was of an unknown type!")
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let building = buildings[(indexPath as NSIndexPath).row]
        let buildingID = building.iID;
        print(buildingID)
        let loginUrl = environment.httpAddress + LecConstants.NetworkSubAddress.GetBuildingDetail
        Alamofire.request(loginUrl, method: .get, parameters: ["buildingID":buildingID]).responseJSON(completionHandler: { [weak weakSelf = self] (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json);
                //if let buildingsArray = json.array {
                //}
            case .failure:
                JDStatusBarNotification.show(withStatus: "登录失败", dismissAfter: 2.0, styleName: JDStatusBarStyleSuccess);
            }})
        
        /*
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
            try LecFileHelper(fileName: "CurrentProject", fileExtension: .JSON, subDirectory: LecConstants.Path.SubDirectoryName).saveFile(dataBuilding)
            LecSocketManager.sharedSocket.dataModel.loadData()
            delegate?.configViewController(self, didChooseBuilding: building)
        } catch {
            
        }
        
        */
    }
    
    func getCurrentFloors(_ buildingId: String) -> [LecFloor] {
        return floors.filter { $0.buildingId == buildingId}
    }
    
    func getCurrentAreas(_ buildingId: String) -> [LecArea] {
        let floors = getCurrentFloors(buildingId).map { $0.floorId }
        return areas.filter{ floors.contains($0.floorId) }
    }
    
    func getCurrentDevices(_ buildingId: String) -> [LecDevice] {
        let areas = getCurrentAreas(buildingId).map { $0.areaId }
        return devices.filter{ areas.contains($0.areaId) }
    }
    
    func getCurrentCams(_ buildingId: String) -> [LecCam] {
        let devices = getCurrentDevices(buildingId).map { $0.deviceId }
        return cams.filter{ devices.contains( $0.deviceId ) }
    }
}

