//
//  LecSceneCell.swift
//  LeControl
//
//  Created by 新 范 on 16/8/27.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit

let imgs = ["mode_back_home","mode_leave_home","mode_receive","mode_video"]

class LecSceneCell: UICollectionViewCell {
    @IBOutlet weak var sceneImageView: UIImageView!
    @IBOutlet weak var sceneNameLabel: UILabel!
    
    let img = imgs[Int(arc4random_uniform(3))]
    
    var norImageName = ""
    var selImageName = ""

    var scene: LecDevice? {
        didSet {
            if let scene = self.scene {
                norImageName = scene.imageName + "_nor"
                selImageName = scene.imageName + "_sel"
                if let sceneNameLabel = self.sceneNameLabel {
                    sceneNameLabel.text = scene.name
                }
                if let sceneImageView = self.sceneImageView {
                    sceneImageView.image = UIImage(named: norImageName)
                }
            }
        }
    }
    
    var cams: [LecCam]?
    
    override var isSelected: Bool {
        get {
            return super.isSelected
        }
        set {
            if newValue {
                super.isSelected = true
                sceneImageView.image = UIImage(named: selImageName)
                sceneNameLabel.textColor = LecConstants.AppColor.CamTintColor
            } else if newValue == false {
                super.isSelected = false
                sceneImageView.image = UIImage(named: norImageName)
                sceneNameLabel.textColor = UIColor.white
            }
        }
    }
}
