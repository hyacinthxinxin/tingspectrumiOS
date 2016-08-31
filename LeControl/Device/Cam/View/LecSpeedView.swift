//
//  LecSpeedView.swift
//  LeControl
//
//  Created by 新 范 on 16/8/27.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit
import PureLayout

private let openImage = UIImage(named: "open")
private let openClickImage = UIImage(named: "open_click")
private let closeImage = UIImage(named: "close")
private let closeClickImage = UIImage(named: "close_click")
private let upImage = UIImage(named: "up")
private let upClickImage = UIImage(named: "up_click")
private let downImage = UIImage(named: "down")
private let downClickImage = UIImage(named: "down_click")
private let pasueImage = UIImage(named: "pause")
private let pasueClickImage = UIImage(named: "pause_click")

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
    
    private func setupSubviews() {

        if let cams = self.cams {
            let titles = cams.map { $0.camName }
            speedSlider = LecStepSlider(titles: titles)
            if let speedSlider = self.speedSlider {
                speedSlider.backgroundColor = LecConstants.AppColor.ThemeBGColor
                speedSlider.selectedIndex = 0
                speedSlider.addTarget(self, action: #selector(LecSpeedView.speedChange(_:)), forControlEvents: .ValueChanged)
                addSubview(speedSlider)
            }
        }
        
        speedNameLabel = UILabel()
        if let dView = self.speedNameLabel {
            dView.font = UIFont.systemFontOfSize(15)
            dView.textColor = UIColor.whiteColor()
            dView.text = "风速控制"
            addSubview(dView)
        }
        
        separatorView = UIView()
        if let sView = self.separatorView {
            sView.backgroundColor = LecConstants.AppColor.SeparatorColor
            addSubview(sView)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let dView = self.speedNameLabel {
            dView.autoPinEdgeToSuperviewEdge(.Left, withInset: 14)
            dView.autoPinEdgeToSuperviewEdge(.Top, withInset: 5)
        }

        if let speedSlider = self.speedSlider {
            speedSlider.autoPinEdgeToSuperviewEdge(.Left, withInset: 0)
            speedSlider.autoPinEdgeToSuperviewEdge(.Right, withInset: 0)
            speedSlider.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 0)
            speedSlider.autoPinEdgeToSuperviewEdge(.Top, withInset: 0)
        }
        
        if let sView = self.separatorView {
            sView.autoPinEdgeToSuperviewEdge(.Left, withInset: 0)
            sView.autoPinEdgeToSuperviewEdge(.Right, withInset: 0)
            sView.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 0)
            sView.autoSetDimension(.Height, toSize: 0.5)
        }

    }

    override func refreshState(feedbackAddress: String, statusValue: Int) {
        if let cams = self.cams {
            for cam in cams {
                if cam.statusAddress == feedbackAddress && cam.statusValue == statusValue {
                    if let index = cams.indexOf(cam) {
                        speedSlider?.selectedIndex = index
                    }
                    return
                }
            }
        }
    }

    func speedChange(sender: LecStepSlider) {
        if let cams = self.cams {
            let cam  = cams[sender.selectedIndex]
            LecSocketManager.sharedSocket.sendMessageWithCam(cam)
        }
    }
    
}