//
//  LecDeviceCell.swift
//  LeControl
//
//  Created by 新 范 on 16/8/27.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit

class LecDeviceCell: UITableViewCell {

    var device: LecDevice? {
        didSet {
            if let device = self.device {
                print(device)
//                if let sceneNameLabel = self.sceneNameLabel {
//                    sceneNameLabel.text = device.deviceName
//                }
//                if let sceneImageView = self.sceneImageView {
//                    sceneImageView.image = UIImage(named: img + "_nor")
//                }
                
            }
        }
    }
    
    var cams: [LecCam]? {
        didSet {
            if let cams = self.cams {
                for c in cams {
                    print(c.camType)
                }
            }
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
