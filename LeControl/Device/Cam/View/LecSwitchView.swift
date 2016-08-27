//
//  LecSwitchView.swift
//  LeControl
//
//  Created by 新 范 on 16/8/27.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit
import PureLayout

class LecSwitchView: LecCamView {
    private var didSetupConstraints = false
    private var containerView: UIView?

    @IBOutlet weak var camNameLabel: UILabel!
    @IBOutlet weak var camSwitch: UISwitch!
    
    func loadViewFfromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: String(self.dynamicType), bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        setupSubviews()
    }
    
    func commonInit() {
        
    }
    
    func setupSubviews() {
        containerView = loadViewFfromNib()
        containerView?.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        if let cView = containerView {
            addSubview(cView)
        }
        setNeedsUpdateConstraints() // bootstrap Auto Layout
    }
    
    override func updateConstraints() {
        if (!didSetupConstraints) {
            if let cview = containerView {
                cview.autoPinEdgeToSuperviewEdge(.Bottom)
                cview.autoPinEdgeToSuperviewEdge(.Trailing)
                cview.autoPinEdgeToSuperviewEdge(.Leading)
                cview.autoPinEdgeToSuperviewEdge(.Top)
            }
            didSetupConstraints = true
        }
        super.updateConstraints()
    }
    
    @IBAction func switchCam(sender: UISwitch) {
        print(cams?.first)
    }

}
