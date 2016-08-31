//
//  LecCurtainView.swift
//  LeControl
//
//  Created by 新 范 on 16/8/27.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit
import PureLayout

//private let openImage = UIImage(named: "open")?.imageWithRenderingMode(.AlwaysTemplate)


class LecCurtainView: LecCamView {
    
    var didSetupConstraints = false
    var curtainNameLabel: UILabel?
    var curtainButtons = [UIButton]()
    
    let norImages = [UIImage(named: "open"),
                     UIImage(named: "close"),
                     UIImage(named: "up"),
                     UIImage(named: "down"),
                     UIImage(named: "pause")]
    
    convenience init(cams: [LecCam]) {
        self.init(frame: CGRect.zero)
        backgroundColor = LecConstants.AppColor.ThemeBGColor
        self.cams = cams
        setupSubviews()
    }
    
    private func setupSubviews() {
        curtainNameLabel = UILabel()
        if let dView = self.curtainNameLabel {
            dView.font = UIFont.systemFontOfSize(13)
            dView.textColor = UIColor.whiteColor()
            addSubview(dView)
        }
        
        if let cams = self.cams {
            for cam in cams {
                let cView = UIButton(type: .Custom)
//                cView.layer.borderWidth = 1
                cView.setButtonImage(cam.camType)
                cView.showsTouchWhenHighlighted = true
                cView.adjustsImageWhenHighlighted = false
                cView.tag = cam.camType
                cView.tintColor = LecConstants.AppColor.CamTintColor
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
        if let dView = self.curtainNameLabel {
            dView.autoPinEdgeToSuperviewEdge(.Left, withInset: 14)
            dView.autoPinEdgeToSuperviewEdge(.Top, withInset: 10)
        }
        
        let views: NSArray = curtainButtons
        views.autoAlignViewsToEdge(.Bottom)
        views.autoAlignViewsToEdge(.Top)
        views.autoDistributeViewsAlongAxis(.Horizontal, alignedTo: .Horizontal, withFixedSpacing: 20.0, insetSpacing: true, matchedSizes: true)
        curtainButtons.first!.autoAlignAxisToSuperviewAxis(.Horizontal)
        curtainButtons.first!.autoSetDimension(.Height, toSize: LecConstants.DeviceCellHeight.Curtain_Curtain - 40)
    }
    
//    var isHighLighted:Bool = false

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
        
        delay(seconds: 0.2) {
            sender.selected = false
        }
    }
}

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

extension UIButton {
    
    private func setButtonImage(type: Int) {
        guard (30...34).contains(type) else { return }
        switch type {
        case 30:
            setImage(openImage, forState: .Normal)
            setImage(openClickImage, forState: .Highlighted)
            setImage(openClickImage, forState: .Selected)
        case 31:
            setImage(closeImage, forState: .Normal)
            setImage(closeClickImage, forState: .Highlighted)
            setImage(closeClickImage, forState: .Selected)
        case 32:
            setImage(upImage, forState: .Normal)
            setImage(upClickImage, forState: .Highlighted)
            setImage(upClickImage, forState: .Selected)
        case 33:
            setImage(downImage, forState: .Normal)
            setImage(downClickImage, forState: .Highlighted)
            setImage(downClickImage, forState: .Selected)
        case 34:
            setImage(pasueImage, forState: .Normal)
            setImage(pasueClickImage, forState: .Highlighted)
            setImage(pasueClickImage, forState: .Selected)
        default:
            break
        }
    }
}