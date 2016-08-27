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
    private var didSetupConstraints = false
    
    var modelButtons = [UIButton]()
    let buttonSpacing = 5

    let filledStarImage = UIImage(named: "mode_refrigeration")
    let emptyStarImage = UIImage(named: "mode_heating")
    
    let images = ["mode_heating", "mode_refrigeration", "mode_ventilation", "mode_desiccant"]
    
    override var cams: [LecCam]? {
        didSet {
            print(cams)
            if let cams = self.cams {
                for cam in cams {
                    let cView = UIButton()
                    cView.layer.borderWidth = 1
                    cView.setImage(emptyStarImage, forState: .Normal)
                    cView.setImage(filledStarImage, forState: .Selected)
                    cView.setImage(filledStarImage, forState: [.Highlighted, .Selected])
                    cView.adjustsImageWhenHighlighted = false
                    //            cView.tag = c
                    cView.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                    cView.setTitleColor(themeColor, forState: .Selected)
                    cView.setTitleColor(themeColor, forState: [.Highlighted, .Selected])
                    cView.setTitle(cam.camName, forState: .Normal)
                    modelButtons += [cView]
                    addSubview(cView)
                }
                setNeedsUpdateConstraints() // bootstrap Auto Layout
            }
        }
    }

    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        backgroundColor = themeBGColor
    }
    
    override func updateConstraints() {
        if (!didSetupConstraints) {
            let views: NSArray = modelButtons
            views.autoSetViewsDimension(.Height, toSize: 62)
            views.autoDistributeViewsAlongAxis(.Horizontal, alignedTo: .Horizontal, withFixedSpacing: 10.0, insetSpacing: true, matchedSizes: true)
            modelButtons.first!.autoAlignAxisToSuperviewAxis(.Horizontal)
            didSetupConstraints = true
        }
        super.updateConstraints()
    }
}
