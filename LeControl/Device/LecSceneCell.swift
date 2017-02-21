//
//  LecSceneCell.swift
//  LeControl
//
//  Created by 新 范 on 16/8/27.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit

//let imgs = ["mode_back_home","mode_leave_home","mode_receive","mode_video"]

class LecSceneCell: UICollectionViewCell {
    @IBOutlet weak var sceneImageView: UIImageView!
    @IBOutlet weak var sceneNameLabel: UILabel!
    
//    let img = imgs[Int(arc4random_uniform(3))]
    
    var norImageName = ""
    var selImageName = ""

    var scene: LecDevice? {
        didSet {
            if let scene = self.scene {
                norImageName = "mode_" + scene.imageName + "_nor"
                selImageName = "mode_" + scene.imageName + "_sel"
                if let sceneNameLabel = self.sceneNameLabel {
                    sceneNameLabel.text = scene.name
                }
                if let sceneImageView = self.sceneImageView {
                    if let img = UIImage(named: norImageName) {
                        sceneImageView.image = img
                    } else {
                        sceneImageView.image = UIImage(named: "mode_other_nor")
                    }
                    
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
                if let img = UIImage(named: selImageName) {
                    sceneImageView.image = img
                } else {
                    sceneImageView.image = UIImage(named: "mode_other_sel")
                }
                sceneNameLabel.textColor = LecConstants.AppColor.CamTintColor
            } else if newValue == false {
                super.isSelected = false
                if let img = UIImage(named: norImageName) {
                    sceneImageView.image = img
                } else {
                    sceneImageView.image = UIImage(named: "mode_other_nor")
                }
                sceneNameLabel.textColor = UIColor.white
            }
        }
    }
}
