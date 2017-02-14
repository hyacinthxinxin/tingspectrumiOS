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
        let loginUrl = environment.httpAddress + LecConstants.NetworkSubAddress.Buildings
        Alamofire.request(loginUrl, method: .get, parameters: ["user_id":userID]).responseJSON(completionHandler: { [weak weakSelf = self] (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let buildingsArray = json.array {
                    weakSelf?.buildings = buildingsArray.map {
                        let building = LecBuilding()
                        if let buildingID = $0["id"].int {
                            building.iId = buildingID
                        }
                        if let name = $0["name"].string {
                            building.name = name
                        }
                        if let socketAddress = $0["socket_address"].string {
                            building.socketAddress = socketAddress
                        }
                        if let socketPort = $0["socket_port"].int{
                            building.socketPort = UInt16(socketPort)
                        }
                        return building
                    }
                    weakSelf?.tableView.reloadData()
                }
            case .failure:
                JDStatusBarNotification.show(withStatus: "登录失败", dismissAfter: 2.0, styleName: JDStatusBarStyleSuccess);
            }})
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
        LecSocketManager.sharedSocket.dataModel.building = building;
        
        let projectUrl = environment.httpAddress + LecConstants.NetworkSubAddress.GetBuildingDetail
        let parameters = ["building_id":building.iId]
        
        Alamofire.request(projectUrl, method: .get, parameters: parameters).responseJSON(completionHandler: { [weak weakSelf = self] (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                do {
                    let dataCurrentBuilding = try json.rawData()
                    try LecFileHelper(fileName: "CurrentProject", fileExtension: .JSON, subDirectory: LecConstants.Path.SubDirectoryName).saveFile(dataCurrentBuilding)
                    LecSocketManager.sharedSocket.dataModel.loadData()
                    weakSelf?.delegate?.configViewController(self, didChooseBuilding: building)
                } catch {
                    
                }
            case .failure:
                JDStatusBarNotification.show(withStatus: "登录失败", dismissAfter: 2.0, styleName: JDStatusBarStyleSuccess);
            }})
    }
}

