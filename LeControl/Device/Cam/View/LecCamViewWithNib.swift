//
//  LecCamViewWithNib.swift
//  LeControl
//
//  Created by 新 范 on 16/8/27.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit

class LecCamViewWithNib: LecCamView {

    fileprivate var didSetupConstraints = false
    fileprivate var containerView: UIView?
    
    func loadViewFfromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
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
        containerView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if let cView = containerView {
            addSubview(cView)
        }
        setNeedsUpdateConstraints() // bootstrap Auto Layout
    }
    
    override func updateConstraints() {
        if (!didSetupConstraints) {
            if let cview = containerView {
                cview.autoPinEdge(toSuperviewEdge: .bottom)
                cview.autoPinEdge(toSuperviewEdge: .right)
                cview.autoPinEdge(toSuperviewEdge: .left)
                cview.autoPinEdge(toSuperviewEdge: .top)
            }
            didSetupConstraints = true
        }
        super.updateConstraints()
    }
}
