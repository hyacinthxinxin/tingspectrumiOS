//
//  LecSceneViewController.swift
//  LeControl
//
//  Created by 新 范 on 16/8/27.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit

class LecSceneViewController: UIViewController {
    var devices: [LecDevice]! {
        didSet {
            let deviceIds = devices.map { $0.deviceID }
            cams = LecSocketManager.sharedSocket.dataModel.cams.filter{ deviceIds.contains( $0.deviceID ) }
        }
    }
    var cams: [LecCam]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: UICollectionViewDataSource

extension LecSceneViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return devices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LecConstants.ReuseIdentifier.SceneCell, for: indexPath) as? LecSceneCell {
            let scene = devices[(indexPath as NSIndexPath).row]
            cell.scene = scene
            cell.cams = cams.filter { $0.deviceID == scene.deviceID }
            return cell
        }
        assert(false, "The dequeued collection view cell was of an unknown type!")
        return UICollectionViewCell()
    }
}

// MARK: UICollectionViewDelegate

extension LecSceneViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? LecSceneCell {
            if let cams = cell.cams, let cam = cams.first {
                LecSocketManager.sharedSocket.sendMessageWithCam(cam)
            }
        }
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension LecSceneViewController: UICollectionViewDelegateFlowLayout {
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
        return view.window!.rootViewController!.traitCollection.horizontalSizeClass == .compact ? (screenWidth - 2 * cellWidth) / 3 : hSpacing
    }
}

