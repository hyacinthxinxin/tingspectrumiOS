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
    }
    
    func speedChange(sender: LecStepSlider) {
        if let cams = self.cams {
            let cam  = cams[sender.selectedIndex]
            LecSocketManager.sharedSocket.sendMessageWithCam(cam)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let speedSlider = self.speedSlider {
            speedSlider.autoPinEdgeToSuperviewEdge(.Left, withInset: 0)
            speedSlider.autoPinEdgeToSuperviewEdge(.Right, withInset: 0)
            speedSlider.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 0)
            speedSlider.autoPinEdgeToSuperviewEdge(.Top, withInset: 0)

        }
    }
}

extension LecSpeedView: LecCamViewUpdateDelegate {
    func updateView() {
        if let cams = self.cams {
            //
        }
    }
}