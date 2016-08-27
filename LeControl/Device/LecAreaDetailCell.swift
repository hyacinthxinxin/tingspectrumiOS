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
                }
            }
        }
    }
}
