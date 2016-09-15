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
    
    fileprivate func setupSubviews() {
        curtainNameLabel = UILabel()
        if let dView = self.curtainNameLabel {
            dView.font = UIFont.systemFont(ofSize: 13)
            dView.textColor = UIColor.white
            addSubview(dView)
        }
        
        if let cams = self.cams {
            for cam in cams {
                let cView = UIButton(type: .custom)
//                cView.layer.borderWidth = 1
                cView.setButtonImage(cam.camType)
                cView.showsTouchWhenHighlighted = true
                cView.adjustsImageWhenHighlighted = false
                cView.tag = cam.camType
                cView.tintColor = LecConstants.AppColor.CamTintColor
                cView.setTitleColor(UIColor.white, for: UIControlState())
                cView.setTitleColor(LecConstants.AppColor.CamTintColor, for: .selected)
                cView.setTitleColor(LecConstants.AppColor.CamTintColor, for: [.highlighted, .selected])
                cView.setTitle(cam.camName, for: UIControlState())
                cView.addTarget(self, action: #selector(camButtonTapped), for: .touchUpInside)
                cView.titleLabel?.font = UIFont.systemFont(ofSize: 13)
                cView.setButtonSpacing(14)
                curtainButtons += [cView]
                addSubview(cView)
            }
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
    
//    var isHighLighted:Bool = false

    func camButtonTapped(_ sender: UIButton) {
        for b in curtainButtons {
            b.isSelected = sender === b
        }
        if let cams = self.cams {
            let cs = cams.filter { $0.camType == sender.tag }
            if let cam = cs.first {
                LecSocketManager.sharedSocket.sendMessageWithCam(cam)
            }
        }
        
        delay(seconds: 0.2) {
            sender.isSelected = false
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
    
    fileprivate func setButtonImage(_ type: Int) {
        guard (30...34).contains(type) else { return }
        switch type {
        case 30:
            setImage(openImage, for: UIControlState())
            setImage(openClickImage, for: .highlighted)
            setImage(openClickImage, for: .selected)
        case 31:
            setImage(closeImage, for: UIControlState())
            setImage(closeClickImage, for: .highlighted)
            setImage(closeClickImage, for: .selected)
        case 32:
            setImage(upImage, for: UIControlState())
            setImage(upClickImage, for: .highlighted)
            setImage(upClickImage, for: .selected)
        case 33:
            setImage(downImage, for: UIControlState())
            setImage(downClickImage, for: .highlighted)
            setImage(downClickImage, for: .selected)
        case 34:
            setImage(pasueImage, for: UIControlState())
            setImage(pasueClickImage, for: .highlighted)
            setImage(pasueClickImage, for: .selected)
        default:
            break
        }
    }
}
