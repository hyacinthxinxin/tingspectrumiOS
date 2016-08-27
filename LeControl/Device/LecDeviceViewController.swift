//
//  LecDeviceViewController.swift
//  LeControl
//
//  Created by 新 范 on 16/8/23.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit

class LecDeviceViewController: UIViewController {

    var dataModel: LecDataModel!

    var devices: [LecDevice]! {
        didSet {
            let deviceIds = devices.map { $0.deviceId }
            cams = dataModel.cams.filter{ deviceIds.contains( $0.deviceId ) }
        }
    }
    var cams: [LecCam]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for d in devices {
            print(d.deviceName)
        }
        for c in cams {
            print(c.camName)
        }
    }
}
