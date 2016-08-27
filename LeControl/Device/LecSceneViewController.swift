//
//  LecSceneViewController.swift
//  LeControl
//
//  Created by 新 范 on 16/8/27.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit

class LecSceneViewController: UIViewController {
    var dataModel: LecDataModel!
    
    var devices: [LecDevice]! {
        didSet {
            let deviceIds = devices.map { $0.deviceId }
            cams = dataModel.cams.filter{ deviceIds.contains( $0.deviceId ) }
        }
    }
    var cams: [LecCam]!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: UICollectionViewDataSource

extension LecSceneViewController: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return devices.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier(LecConstants.ReuseIdentifier.SceneCell, forIndexPath: indexPath) as? LecSceneCell {
            let scene = devices[indexPath.row]
            cell.scene = scene
            cell.cams = cams.filter { $0.deviceId == scene.deviceId }
            return cell
        }
        assert(false, "The dequeued collection view cell was of an unknown type!")
        return UICollectionViewCell()
    }
}

// MARK: UICollectionViewDelegate

extension LecSceneViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? LecSceneCell {
            if let cams = cell.cams, let cam = cams.first {
                LecSocketManager.sharedSocket.sendMessageWithCam(cam)
            }
        }
    }
    
}


