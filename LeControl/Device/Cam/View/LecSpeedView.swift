//
//  LecSpeedView.swift
//  LeControl
//
//  Created by 新 范 on 16/8/27.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit
import PureLayout

class LecSpeedView: LecCamView {
    
    var didSetupConstraints = false
    var speedButtons = [UIButton]()
    var speedSlider: LecStepSlider?
    var speedNameLabel: UILabel?
    var separatorView: UIView?
    
    convenience init(cams: [LecCam]) {
        self.init(frame: CGRect.zero)
        backgroundColor = LecConstants.AppColor.ThemeBGColor
        self.cams = cams
        setupSubviews()
    }
    
    fileprivate func setupSubviews() {
        let titles = cams.map { $0.name }
        speedSlider = LecStepSlider(titles: titles)
        if let speedSlider = self.speedSlider {
            speedSlider.backgroundColor = LecConstants.AppColor.ThemeBGColor
            speedSlider.selectedIndex = 0
            speedSlider.addTarget(self, action: #selector(LecSpeedView.speedChange(_:)), for: .valueChanged)
            addSubview(speedSlider)
        }
        
        speedNameLabel = UILabel()
        if let speedNameLabel = self.speedNameLabel {
            speedNameLabel.font = UIFont.systemFont(ofSize: 13)
            speedNameLabel.textColor = UIColor.white
            speedNameLabel.text = "风速控制"
            addSubview(speedNameLabel)
        }
        
        separatorView = UIView()
        if let sView = self.separatorView {
            sView.backgroundColor = LecConstants.AppColor.SeparatorColor
            addSubview(sView)
        }
        
        for cam in cams {
            if cam.isChecked {
                if let index = cams.index(of: cam) {
                    speedSlider?.selectedIndex = index
                }
                return
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let speedNameLabel = self.speedNameLabel {
            speedNameLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 14)
            speedNameLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 5)
        }
        
        if let speedSlider = self.speedSlider {
            speedSlider.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            speedSlider.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            speedSlider.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
            speedSlider.autoPinEdge(toSuperviewEdge: .top, withInset: 15)
        }
        
        if let separatorView = self.separatorView {
            separatorView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            separatorView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            separatorView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
            separatorView.autoSetDimension(.height, toSize: 0.5)
        }
    }
    
    @objc func speedChange(_ sender: LecStepSlider) {
        if let cams = self.cams {
            let cam  = cams[sender.selectedIndex]
            cam.isChecked = true
            for c in cams.filter({$0.iId != cam.iId}) {
                c.isChecked = false
            }
            LecSocketManager.sharedSocket.sendMessageWithCam(cam)
        }
    }
    
}
