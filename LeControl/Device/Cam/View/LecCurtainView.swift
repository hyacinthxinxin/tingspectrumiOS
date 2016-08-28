//
//  LecCurtainView.swift
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

class LecCurtainView: LecCamView {
    
    var didSetupConstraints = false
    var curtainButtons = [UIButton]()
    
    convenience init(cams: [LecCam]) {
        self.init(frame: CGRect.zero)
        backgroundColor = LecConstants.AppColor.ThemeBGColor
        self.cams = cams
        setupSubviews()
    }
    
    private func setupSubviews() {
        if let cams = self.cams {
            for cam in cams {
                let cView = UIButton()
//                cView.layer.borderWidth = 1
                switch cam.camType {
                case 30:
                    cView.setImage(openImage, forState: .Normal)
                    cView.setImage(openClickImage, forState: .Selected)
                    cView.setImage(openClickImage, forState: [.Highlighted, .Selected])
                    
                case 31:
                    cView.setImage(closeImage, forState: .Normal)
                    cView.setImage(closeClickImage, forState: .Selected)
                    cView.setImage(closeClickImage, forState: [.Highlighted, .Selected])
                    
                case 32:
                    cView.setImage(upImage, forState: .Normal)
                    cView.setImage(upClickImage, forState: .Selected)
                    cView.setImage(upClickImage, forState: [.Highlighted, .Selected])
                    
                case 33:
                    cView.setImage(downImage, forState: .Normal)
                    cView.setImage(downClickImage, forState: .Selected)
                    cView.setImage(downClickImage, forState: [.Highlighted, .Selected])
                    
                case 34:
                    cView.setImage(pasueImage, forState: .Normal)
                    cView.setImage(pasueClickImage, forState: .Selected)
                    cView.setImage(pasueClickImage, forState: [.Highlighted, .Selected])
                default:
                    break
                }
                cView.adjustsImageWhenHighlighted = false
                cView.tag = cam.camType
                cView.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                cView.setTitleColor(LecConstants.AppColor.CamTintColor, forState: .Selected)
                cView.setTitleColor(LecConstants.AppColor.CamTintColor, forState: [.Highlighted, .Selected])
                cView.setTitle(cam.camName, forState: .Normal)
                cView.addTarget(self, action: #selector(camButtonTapped), forControlEvents: .TouchUpInside)
                cView.titleLabel?.font = UIFont.systemFontOfSize(13)
                cView.setButtonSpacing(14)
                curtainButtons += [cView]
                addSubview(cView)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let views: NSArray = curtainButtons
        views.autoAlignViewsToEdge(.Bottom)
        views.autoAlignViewsToEdge(.Top)
        views.autoDistributeViewsAlongAxis(.Horizontal, alignedTo: .Horizontal, withFixedSpacing: 20.0, insetSpacing: true, matchedSizes: true)
        curtainButtons.first!.autoAlignAxisToSuperviewAxis(.Horizontal)
        curtainButtons.first!.autoSetDimension(.Height, toSize: LecConstants.DeviceCellHeight.Curtain - 40)
        //            curtainButtons.first!.autoPinEdgeToSuperviewEdge(.Top, withInset: 15)
        //            curtainButtons.first!.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 15)
    }
    
    func camButtonTapped(sender: UIButton) {
        for b in curtainButtons {
            b.selected = sender === b
        }
        if let cams = self.cams {
            let cs = cams.filter { $0.camType == sender.tag }
            if let cam = cs.first {
                LecSocketManager.sharedSocket.sendMessageWithCam(cam)
            }
        }
    }
}