//
//  LecDeviceCell.swift
//  LeControl
//
//  Created by 新 范 on 16/8/27.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit

class LecDeviceCell: UITableViewCell {

    var device: LecDevice?
    
    var cams: [LecCam]?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = LecConstants.AppColor.ThemeBGColor
        selectionStyle = .None
    }
}
