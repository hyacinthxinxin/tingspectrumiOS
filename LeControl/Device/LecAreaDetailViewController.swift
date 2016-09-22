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

private let deviceGroupTypeImageNameDictionary = [LecDeviceGroupType.groupScene: detailImageNames[0],
                                                  LecDeviceGroupType.groupLight: detailImageNames[1],
                                                  LecDeviceGroupType.groupTemperature: detailImageNames[2],
                                                  LecDeviceGroupType.groupCurtain: detailImageNames[3]]

private let deviceGroupTypeDescriptionDictionary = [LecDeviceGroupType.groupScene: detailNames[0],
                                                    LecDeviceGroupType.groupLight: detailNames[1],
                                                    LecDeviceGroupType.groupTemperature: detailNames[2],
                                                    LecDeviceGroupType.groupCurtain: detailNames[3]]


enum LecDeviceGroupType {
    case groupScene
    case groupLight
    case groupTemperature
    case groupCurtain
    
    var description: String{
        return deviceGroupTypeDescriptionDictionary[self] ?? "未知的"
    }
    
    var groupImageName: String {
        return deviceGroupTypeImageNameDictionary[self] ?? "unkown"
    }
}

class LecAreaDetailViewController: UICollectionViewController {
    var area: LecArea! {
        didSet {
            devices = LecSocketManager.sharedSocket.dataModel.devices.filter { $0.areaID == area.areaID }
            self.configureView()
        }
    }
    
    var devices: [LecDevice]!
    
    var groupTypes: [LecDeviceGroupType] {
        if let _  = devices {
            var g = [LecDeviceGroupType]()
            if (devices.contains{ $0.iType == .scene }) {
                g.append(.groupScene)
            }
            if (devices.contains{ $0.iType == .light || $0.iType == .lightDimming}) {
                g.append(.groupLight)
            }
            if (devices.contains{ $0.iType == .airConditioning } || devices.contains{ $0.iType == .floorHeating } || devices.contains{ $0.iType == .freshAir }) {
                g.append(.groupTemperature)
            }
            if (devices.contains{ $0.iType == .curtain }) {
                g.append(.groupCurtain)
            }
            return g
        }
        return [LecDeviceGroupType]()
    }
    
    func configureView() {
        title = area.name
        collectionView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case LecConstants.SegueIdentifier.ShowScene:
                let sceneViewController = segue.destination as! LecSceneViewController
                sceneViewController.title = LecDeviceGroupType.groupScene.description
                sceneViewController.devices = devices.filter { $0.iType == .scene }

            case LecConstants.SegueIdentifier.ShowDevice:
                let deviceViewController = segue.destination as! LecDeviceViewController
                let cell = sender as! LecAreaDetailCell
                if let deviceGroupType = cell.deviceGroupType {
                    deviceViewController.title = deviceGroupType.description
                    switch deviceGroupType {
                    case .groupScene:
                        deviceViewController.devices = devices.filter { $0.iType == .scene }
                    case .groupLight:
                        var ds = devices.filter { $0.iType == .light }
                        ds += devices.filter { $0.iType == .lightDimming }
                        deviceViewController.devices = ds
                    case .groupTemperature:
                        var ds = devices.filter { $0.iType == .airConditioning }
                        ds += devices.filter { $0.iType == .floorHeating }
                        ds += devices.filter { $0.iType == .freshAir }
                        deviceViewController.devices = ds
                    case .groupCurtain:
                        deviceViewController.devices = devices.filter { $0.iType == .curtain}
                    }
                }
                
            default: break
            }
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groupTypes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LecConstants.ReuseIdentifier.AreaDetailCell, for: indexPath) as? LecAreaDetailCell {
            cell.deviceGroupType = groupTypes[(indexPath as NSIndexPath).row]
            return cell
        }
        assert(false, "The dequeued collection view cell was of an unknown type!")
        return UICollectionViewCell()
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? LecAreaDetailCell {
            if cell.deviceGroupType == .groupScene {
                performSegue(withIdentifier: LecConstants.SegueIdentifier.ShowScene, sender: cell)
            } else {
                performSegue(withIdentifier: LecConstants.SegueIdentifier.ShowDevice, sender: cell)
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

// MARK: - UICollectionViewDelegateFlowLayout

let cellWidth: CGFloat = 80.0
let cellHeight: CGFloat = 196.0
let hMargin: CGFloat = 70.0
let hSpacing: CGFloat = 76.0

extension LecAreaDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 80, height: 196)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return view.window!.rootViewController!.traitCollection.horizontalSizeClass == .compact ? UIEdgeInsets(top:148 - 64, left:(screenWidth - 2 * cellWidth) / 3 - 2, bottom:0, right:(screenWidth - 2 * cellWidth) / 3 - 2) : UIEdgeInsets(top:148 - 64, left:hMargin, bottom: 0, right:hMargin)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return  view.window!.rootViewController!.traitCollection.horizontalSizeClass == .compact ? (screenWidth - 2 * cellWidth) / 3 : hSpacing
    }
}
