//
//  LecCurtainView.swift
//  LeControl
//
//  Created by 新 范 on 16/8/27.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit
import PureLayout

class LecCurtainView: LecCamView {
    
    var didSetupConstraints = false
    var curtainNameLabel: UILabel?
    var curtainButtons = [UIButton]()
    
    convenience init(cams: [LecCam]) {
        self.init(frame: CGRect.zero)
        backgroundColor = LecConstants.AppColor.ThemeBGColor
        self.cams = cams
        setupSubviews()
    }
    
    fileprivate func setupSubviews() {
        curtainNameLabel = UILabel()
        if let dView = self.curtainNameLabel {
            dView.font = UIFont.preferredFont(forTextStyle: .body)
            dView.textColor = UIColor.white
            addSubview(dView)
        }
        
        for cam in cams {
            let curtainButton = UIButton(type: .custom)
            curtainButton.setImage(UIImage(named: cam.getCamImageName(by: cam.iType, isSelected: false)), for: .normal)
            curtainButton.setImage(UIImage(named: cam.getCamImageName(by: cam.iType, isSelected: true)), for: .selected)
            curtainButton.setImage(UIImage(named: cam.getCamImageName(by: cam.iType, isSelected: true)), for: [.highlighted, .selected])
            curtainButton.showsTouchWhenHighlighted = true
            curtainButton.adjustsImageWhenHighlighted = false
            curtainButton.tag = cam.iType
            curtainButton.tintColor = LecConstants.AppColor.CamTintColor
            curtainButton.setTitleColor(UIColor.white, for: .normal)
            curtainButton.setTitleColor(LecConstants.AppColor.CamTintColor, for: .selected)
            curtainButton.setTitleColor(LecConstants.AppColor.CamTintColor, for: [.highlighted, .selected])
            curtainButton.setTitle(cam.name, for: .normal)
            curtainButton.addTarget(self, action: #selector(camButtonTapped), for: .touchUpInside)
            curtainButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            curtainButton.setButtonSpacing(14)
            curtainButtons += [curtainButton]
            addSubview(curtainButton)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let dView = self.curtainNameLabel {
            _ = dView.autoPinEdge(toSuperviewEdge: .left, withInset: 14)
            _ = dView.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
        }
        
        let views: NSArray = curtainButtons as NSArray
        _ = views.autoAlignViews(to: .bottom)
        _ = views.autoAlignViews(to: .top)
        _ = views.autoDistributeViews(along: .horizontal, alignedTo: .horizontal, withFixedSpacing: 20.0, insetSpacing: true, matchedSizes: true)
        _ = curtainButtons.first!.autoAlignAxis(toSuperviewAxis: .horizontal)
        curtainButtons.first!.autoSetDimension(.height, toSize: LecConstants.DeviceCellHeight.Curtain_Curtain - 40)
    }
    
    func camButtonTapped(_ sender: UIButton) {
        sender.isSelected = true
        if let index = curtainButtons.index(of: sender) {
            let cam = cams[index]
            LecSocketManager.sharedSocket.sendMessageWithCam(cam)
        }
        delay(seconds: 0.2) {
            sender.isSelected = false
        }
    }
}

