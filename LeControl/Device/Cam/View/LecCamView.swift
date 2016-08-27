//
//  LecCamView.swift
//  LeControl
//
//  Created by 新 范 on 16/8/27.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit

class LecCamView: UIView {
    
    var cams: [LecCam]? {
        didSet {
            print(cams)
        }
    }
    
}
