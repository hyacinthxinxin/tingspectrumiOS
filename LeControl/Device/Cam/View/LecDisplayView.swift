//
//  LecDisplayView.swift
//  LeControl
//
//  Created by 范新 on 2017/7/12.
//  Copyright © 2017年 TingSpectrum. All rights reserved.
//

import UIKit

class LecDisplayView: LecCamViewWithNib {
    @IBOutlet weak var displayNameView: UILabel!

    @IBOutlet weak var displayValueView: UILabel!

    override var cams: [LecCam]! {
        didSet {
            if let cam = cams.first {
                displayNameView.text = cam.name
                switch cam.iType {
                case 90:
                    displayValueView.text = "\(cam.controlValue)"+"℃"
                case 91:
                    displayValueView.text = "\(cam.controlValue)"+"%RH"
                case 92:
                        displayValueView.text = "\(cam.controlValue)"+"μg/m³"
                default:
                    break
                }
            }
        }
    }

}
