//
//  LecCamViewWithNib.swift
//  LeControl
//
//  Created by 新 范 on 16/8/27.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit

class LecCamViewWithNib: LecCamView {

    private var didSetupConstraints = false
    private var containerView: UIView?
    
    func loadViewFfromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: String(self.dynamicType), bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
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
                cview.autoPinEdgeToSuperviewEdge(.Right)
                cview.autoPinEdgeToSuperviewEdge(.Left)
                cview.autoPinEdgeToSuperviewEdge(.Top)
            }
            didSetupConstraints = true
        }
        super.updateConstraints()
    }
}
