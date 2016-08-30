//
//  LecCamView.swift
//  LeControl
//
//  Created by 新 范 on 16/8/27.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit

protocol LecCamViewUpdateDelegate {
    func refreshState(feedbackAddress: String, statusValue: Int)
}

class LecCamView: UIView {
    var cams: [LecCam]?
}

extension LecCamView: LecCamViewUpdateDelegate {
    func refreshState(feedbackAddress: String, statusValue: Int) {
        
    }
}