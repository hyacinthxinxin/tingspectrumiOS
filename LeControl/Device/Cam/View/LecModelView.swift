
//
//  LecModelView.swift
//  LeControl
//
//  Created by 新 范 on 16/8/27.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit
import PureLayout

private let mode_heatingImage = UIImage(named: "mode_heating")
private let mode_heating_selImage = UIImage(named: "mode_heating_sel")
private let mode_refrigerationImage = UIImage(named: "mode_refrigeration")
private let mode_refrigeration_selImage = UIImage(named: "mode_refrigeration_sel")
private let mode_desiccantImage = UIImage(named: "mode_desiccant")
private let mode_desiccant_selImage = UIImage(named: "mode_desiccant_sel")
private let mode_ventilationImage = UIImage(named: "mode_ventilation")
private let mode_ventilation_selImage = UIImage(named: "mode_ventilation_sel")

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
        if let cams = self.cams {
            for cam in cams {
                let cView = UIButton()
                //                cView.layer.borderWidth = 1
                switch cam.camType {
                case 50:
                    cView.setImage(mode_heatingImage, for: UIControlState())
                    cView.setImage(mode_heating_selImage, for: .selected)
                    cView.setImage(mode_heating_selImage, for: [.highlighted, .selected])
                    
                case 51:
                    cView.setImage(mode_refrigerationImage, for: UIControlState())
                    cView.setImage(mode_refrigeration_selImage, for: .selected)
                    cView.setImage(mode_refrigeration_selImage, for: [.highlighted, .selected])
                    
                case 52:
                    cView.setImage(mode_ventilationImage, for: UIControlState())
                    cView.setImage(mode_ventilation_selImage, for: .selected)
                    cView.setImage(mode_ventilation_selImage, for: [.highlighted, .selected])
                    
                case 53:
                    cView.setImage(mode_desiccantImage, for: UIControlState())
                    cView.setImage(mode_desiccant_selImage, for: .selected)
                    cView.setImage(mode_desiccant_selImage, for: [.highlighted, .selected])
               
                default:
                    break
                }
                
                cView.adjustsImageWhenHighlighted = false
                cView.tag = cam.camType
                cView.setTitleColor(UIColor.white, for: UIControlState())
                cView.setTitleColor(LecConstants.AppColor.CamTintColor, for: .selected)
                cView.setTitleColor(LecConstants.AppColor.CamTintColor, for: [.highlighted, .selected])
                cView.setTitle(cam.camName, for: UIControlState())
                cView.addTarget(self, action: #selector(camButtonTapped), for: .touchUpInside)
                cView.titleLabel?.font = UIFont.systemFont(ofSize: 13)
                cView.setButtonSpacing(14)
                modelButtons += [cView]
                addSubview(cView)
            }
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
    
    override func refreshState(_ feedbackAddress: String, statusValue: Int) {
        if let cams = self.cams {
            for cam in cams {
                if cam.statusAddress == feedbackAddress && cam.statusValue == statusValue {
                    for b in modelButtons {
                        print(b.tag)
                        print(cam.camType)
                        b.isSelected = b.tag == cam.camType
                    }
                    return
                }
            }
//            if let cam = (cams.filter { $0.statusAddress == feedbackAddress && $0.statusValue == statusValue}).first {
//                
//            }
        }
    }

    func camButtonTapped(_ sender: UIButton) {
        for b in modelButtons {
            b.isSelected = sender === b
        }
        if let cams = self.cams {
            let cs = cams.filter { $0.camType == sender.tag }
            if let cam = cs.first {
                LecSocketManager.sharedSocket.sendMessageWithCam(cam)
            }
        }
    }
}
