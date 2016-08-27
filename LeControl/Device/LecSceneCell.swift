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

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    let img = imgs[Int(arc4random_uniform(3))]

    var scene: LecDevice? {
        didSet {
            if let scene = self.scene {
                if let sceneNameLabel = self.sceneNameLabel {
                    sceneNameLabel.text = scene.deviceName
                }
                if let sceneImageView = self.sceneImageView {
                    sceneImageView.image = UIImage(named: img + "_nor")
                }
                
            }
        }
    }
    
    var cams: [LecCam]? {
        didSet {
            
        }
    }
    
    override var selected: Bool {
        get {
            return super.selected
        }
        set {
            if newValue {
                super.selected = true
                sceneImageView.image = UIImage(named: img + "_sel")
            } else if newValue == false {
                super.selected = false
                sceneImageView.image = UIImage(named: img + "_nor")
            }
        }
    }
}
