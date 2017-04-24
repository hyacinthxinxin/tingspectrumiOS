
//
//  LecModelView.swift
//  LeControl
//
//  Created by 新 范 on 16/8/27.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit
import PureLayout

class LecModelView: LecCamView {
    
    var didSetupConstraints = false
    var modelButtons = [UIButton]()
    
    convenience init(cams: [LecCam]) {
        self.init(frame: CGRect.zero)
        backgroundColor = LecConstants.AppColor.ThemeBGColor
        self.cams = cams
        setupSubviews()
    }
    
    fileprivate func setupSubviews() {
        for cam in cams {
            let modelButton = UIButton()
            modelButton.setImage(UIImage(named: cam.getCamImageName(by: cam.iType, isSelected: false)), for: .normal)
            modelButton.setImage(UIImage(named: cam.getCamImageName(by: cam.iType, isSelected: true)), for: .highlighted)
            modelButton.setImage(UIImage(named: cam.getCamImageName(by: cam.iType, isSelected: true)), for: .selected)
            modelButton.adjustsImageWhenHighlighted = false
            modelButton.tag = cam.iType
            modelButton.setTitleColor(UIColor.white, for: .normal)
            modelButton.setTitleColor(LecConstants.AppColor.CamTintColor, for: .selected)
            modelButton.setTitleColor(LecConstants.AppColor.CamTintColor, for: [.highlighted, .selected])
            modelButton.setTitle(cam.name, for: .normal)
            modelButton.addTarget(self, action: #selector(camButtonTapped), for: .touchUpInside)
            modelButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
            modelButton.setButtonSpacing(14)
            modelButton.isSelected = cam.isChecked
            modelButtons += [modelButton]
            addSubview(modelButton)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let views: NSArray = modelButtons as NSArray
        views.autoAlignViews(to: .bottom)
        views.autoAlignViews(to: .top)
        views.autoDistributeViews(along: .horizontal, alignedTo: .horizontal, withFixedSpacing: 20.0, insetSpacing: true, matchedSizes: true)
        modelButtons.first!.autoAlignAxis(toSuperviewAxis: .horizontal)
        modelButtons.first!.autoSetDimension(.height, toSize: LecConstants.DeviceCellHeight.AirConditioning_Model)
    }
    
    func camButtonTapped(_ sender: UIButton) {
        if let index = modelButtons.index(of: sender) {
            let cam = cams[index]
            cam.isChecked = true
            for c in cams.filter({$0.iId != cam.iId}) {
                c.isChecked = false
            }
            for b in modelButtons {
                b.isSelected = false
            }
            sender.isSelected = true
            LecSocketManager.sharedSocket.sendMessageWithCam(cam)
        }
    }
}
