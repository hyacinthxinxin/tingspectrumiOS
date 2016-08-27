//
//  LecLightCell.swift
//  LeControl
//
//  Created by 新 范 on 16/8/27.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit

class LecLightCell: LecDeviceCell {

    @IBOutlet weak var switchView: LecSwitchView!
    
    override var cams: [LecCam]? {
        didSet {
            if let cams = self.cams {
                switchView.cams = cams.filter { $0.camType == 10 }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
}
