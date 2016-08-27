//
//  LecCurtainCell.swift
//  LeControl
//
//  Created by 新 范 on 16/8/27.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit

class LecCurtainCell: LecDeviceCell {

    @IBOutlet weak var curtainView: LecCurtainView!
    
    override var cams: [LecCam]? {
        didSet {
            if let cams = self.cams {
                print(cams)
                curtainView.cams = cams.filter { 30 <= $0.camType && $0.camType < 40 }
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
