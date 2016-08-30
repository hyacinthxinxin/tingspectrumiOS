//
//  LecAreaDetailCell.swift
//  LeControl
//
//  Created by 新 范 on 16/8/23.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit

class LecAreaDetailCell: UICollectionViewCell {
    
    @IBOutlet weak var deviceImageView: UIImageView!
    @IBOutlet weak var deviceNameLabel: UILabel!
    
    var deviceGroupType: LecDeviceGroupType? {
        didSet {
            if let deviceGroupType = self.deviceGroupType {
                if let deviceNameLabel = self.deviceNameLabel {
                    deviceNameLabel.text = deviceGroupType.description
                }
                if let deviceImageView = self.deviceImageView {
                    deviceImageView.image = UIImage(named: deviceGroupType.groupImageName)
                    /*
                    deviceImageView.image = deviceImageView.image?.imageWithRenderingMode(.AlwaysTemplate)
                    deviceImageView.tintColor = UIColor.blackColor()
 */
                    /*
                    let gradient = CAGradientLayer(layer: deviceImageView.layer)
                    gradient.frame = deviceImageView.bounds
                    let centerColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
                    let endColor = UIColor.grayColor()
                    gradient.colors = [endColor.CGColor, centerColor.CGColor, endColor.CGColor]
                    deviceImageView.layer.insertSublayer(gradient, atIndex: 0)
 */
                }
            }
        }
    }
}
