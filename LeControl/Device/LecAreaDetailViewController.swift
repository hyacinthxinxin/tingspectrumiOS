//
//  LecDetailViewController.swift
//  LeControl
//
//  Created by 新 范 on 16/8/23.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit


private let detailNames = ["场景选择", "灯光控制", "温度控制", "窗帘控制"]
private let detailImageNames = ["scenes_choice", "lights_control", "curtains_control", "temperature_control"]

private let deviceGroupTypeImageNameDictionary = [LecDeviceGroupType.GroupScene: detailImageNames[0],
                                                  LecDeviceGroupType.GroupLight: detailImageNames[1],
                                                  LecDeviceGroupType.GroupTemperature: detailImageNames[2],
                                                  LecDeviceGroupType.GroupCurtain: detailImageNames[3]]

private let deviceGroupTypeDescriptionDictionary = [LecDeviceGroupType.GroupScene: detailNames[0],
                                                    LecDeviceGroupType.GroupLight: detailNames[1],
                                                    LecDeviceGroupType.GroupTemperature: detailNames[2],
                                                    LecDeviceGroupType.GroupCurtain: detailNames[3]]


enum LecDeviceGroupType {
    case GroupScene
    case GroupLight
    case GroupTemperature
    case GroupCurtain
    
    var description: String{
        return deviceGroupTypeDescriptionDictionary[self] ?? "未知的"
    }
    
    var groupImageName: String {
        return deviceGroupTypeImageNameDictionary[self] ?? "unkown"
    }
}

class LecAreaDetailViewController: UICollectionViewController {
    var dataModel: LecDataModel!
    
    var area: LecArea! {
        didSet {
            devices = dataModel.devices.filter { $0.areaId == area.areaId }
            self.configureView()
        }
    }
    
    var devices: [LecDevice]!
    
    var groupTypes: [LecDeviceGroupType] {
        var g = [LecDeviceGroupType]()
        if (devices.contains{ $0.deviceType == .Scene }) {
            g.append(.GroupScene)
        }
        if (devices.contains{ $0.deviceType == .Light || $0.deviceType == .LightDimming}) {
            g.append(.GroupLight)
        }
        if (devices.contains{ $0.deviceType == .AirConditioning || $0.deviceType == .FloorHeating }) {
            g.append(.GroupTemperature)
        }
        if (devices.contains{ $0.deviceType == .Curtain }) {
            g.append(.GroupCurtain)
        }
        return g
    }
    
    func configureView() {
        title = area.areaName
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case LecConstants.SegueIdentifier.ShowScene:
                let sceneViewController = segue.destinationViewController as! LecSceneViewController
                sceneViewController.title = LecDeviceGroupType.GroupScene.description
                sceneViewController.dataModel = dataModel
                sceneViewController.devices = devices.filter { $0.deviceType == .Scene }

            case LecConstants.SegueIdentifier.ShowDevice:
                let deviceViewController = segue.destinationViewController as! LecDeviceViewController
                deviceViewController.dataModel = dataModel
                
                let cell = sender as! LecAreaDetailCell
                if let deviceGroupType = cell.deviceGroupType {
                    deviceViewController.title = deviceGroupType.description
                    switch deviceGroupType {
                    case .GroupScene:
                        deviceViewController.devices = devices.filter { $0.deviceType == .Scene }
                    case .GroupLight:
                        deviceViewController.devices = devices.filter { $0.deviceType == .Light || $0.deviceType == .LightDimming}
                    case .GroupTemperature:
                        deviceViewController.devices = devices.filter { $0.deviceType == .AirConditioning || $0.deviceType == .FloorHeating}
                    case .GroupCurtain:
                        deviceViewController.devices = devices.filter { $0.deviceType == .Curtain}
                    }
                }
                
            default: break
            }
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groupTypes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier(LecConstants.ReuseIdentifier.AreaDetailCell, forIndexPath: indexPath) as? LecAreaDetailCell {
            cell.deviceGroupType = groupTypes[indexPath.row]
            return cell
        }
        assert(false, "The dequeued collection view cell was of an unknown type!")
        return UICollectionViewCell()
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? LecAreaDetailCell {
            if cell.deviceGroupType == .GroupScene {
                performSegueWithIdentifier(LecConstants.SegueIdentifier.ShowScene, sender: cell)
            } else {
                performSegueWithIdentifier(LecConstants.SegueIdentifier.ShowDevice, sender: cell)
            }
        }
        
    }
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return false
     }
     
     override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
     return false
     }
     
     override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
     
     }
     */
    
}
