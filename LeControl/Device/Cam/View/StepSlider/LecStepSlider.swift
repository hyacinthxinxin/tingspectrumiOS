//
//  LecStepSlider.swift
//  LeControl
//
//  Created by 新 范 on 16/8/28.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit

let KnobRadius: CGFloat = 31/2+4

let StepSliderLeftOffset: CGFloat = 14+25+16+31/2
let StepSliderRightOffset: CGFloat = 14+25+16+31/2

let StepSliderTitleNormalDistance: CGFloat = 13 + 31/2
let StepSliderTitleSelectedDistance: CGFloat = 4.2
let StepSliderLineHeight: CGFloat = 2
let StepSliderSelectionCirclesRadius : CGFloat = 31/2

class LecStepSliderKnob: UIButton {
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        //Draw Main Cirlce
        context?.setFillColor(LecConstants.AppColor.CamTintColor.cgColor)
        context?.fillEllipse(in: CGRect(x: 0, y: 0, width: KnobRadius * 2, height: KnobRadius * 2))
    }
}

class LecStepSlider: UIControl {

    var labels = [UILabel]()
    var progressColor = themeColor
    var selectedIndex = 0 {
        didSet {
            animateKnobToIndex(selectedIndex)
            animateTitleToIndex(selectedIndex)
        }
    }
    
    var knob = LecStepSliderKnob()
    var diffPoint: CGPoint = CGPoint.zero
    var titles = [String]() {
        didSet {
            setupLables()
        }
    }
    
    var oneSlotSize: CGFloat = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    convenience init(titles: [String]) {
        self.init(frame: CGRect.zero)
        self.titles = titles
        setupLables()
    }
    
    let minimumValueImageView: UIImageView = UIImageView(image: UIImage(named: "wind_smaller"))
    let maximumValueImageView: UIImageView = UIImageView(image: UIImage(named: "wind_bigger"))

    func commonInit() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(LecStepSlider.itemSelected(_:)))
        addGestureRecognizer(tap)
        
        knob.adjustsImageWhenHighlighted = false
        knob.addTarget(self, action: #selector(LecStepSlider.touchDown(_:withEvent:)), for: .touchDown)
        knob.addTarget(self, action: #selector(LecStepSlider.touchUp(_:)), for: .touchUpInside)
        knob.addTarget(self, action: #selector(LecStepSlider.touchMove(_:withEvent:)), for: [.touchDragOutside, .touchDragInside])
        addSubview(knob)
        addSubview(minimumValueImageView)
        addSubview(maximumValueImageView)
    }
    
    func setupLables() {
        for (_, title) in titles.enumerated() {
            let label = UILabel()
            label.backgroundColor = UIColor.clear
            label.text = title
            label.textColor = UIColor.white
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 13)
            labels += [label]
            addSubview(label)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        oneSlotSize = (frame.size.width - StepSliderLeftOffset - StepSliderRightOffset)/CGFloat(titles.count-1)
        knob.frame = CGRect(x: StepSliderLeftOffset, y: frame.size.height/2 - KnobRadius, width: KnobRadius * 2, height: KnobRadius * 2)
        animateKnobToIndex(selectedIndex)
        for (index, label) in labels.enumerated() {
            label.frame = CGRect(x: 0, y: 0, width: oneSlotSize, height: 25)
            label.center = getCenterPointForIndex(index)
        }
        minimumValueImageView.center = CGPoint(x: 23, y: frame.size.height/2)
        maximumValueImageView.center = CGPoint(x: frame.size.width - 23, y: frame.size.height/2)
    }
    
    // MARK - Actions
    
    func itemSelected(_ tap: UITapGestureRecognizer) {
        selectedIndex = getSelectedIndexInPoint(tap.location(in: self))
        sendActions(for: .touchUpInside)
        sendActions(for: .valueChanged)
    }
    
    func touchDown(_ sender: UIButton, withEvent event: UIEvent) {
        if let currentPoint = event.allTouches?.first?.location(in: self) {
            diffPoint = CGPoint(x: currentPoint.x - sender.frame.origin.x, y: currentPoint.y - sender.frame.origin.y)
        }
        sendActions(for: .touchDown)
    }
    
    func touchUp(_ sender: UIButton) {
        selectedIndex = getSelectedIndexInPoint(sender.center)
        animateKnobToIndex(selectedIndex)
        sendActions(for: .touchUpInside)
        sendActions(for: .valueChanged)
    }
    
    func touchMove(_ sender: UIButton, withEvent event: UIEvent) {
        if let currentPoint = event.allTouches?.first?.location(in: self) {
            var toPoint = CGPoint(x: currentPoint.x - diffPoint.x, y: knob.frame.origin.y)
            toPoint = fixFinalPoint(toPoint)
            knob.frame = CGRect(x: toPoint.x, y: toPoint.y, width: knob.frame.size.width, height: knob.frame.size.height)
        }
        
        let selected = getSelectedIndexInPoint(sender.center)
        animateTitleToIndex(selected)
        sendActions(for: .touchDragInside)
    }
    
    fileprivate func getSelectedIndexInPoint(_ point: CGPoint) -> Int {
        let p = Float((point.x - StepSliderLeftOffset)/oneSlotSize)
        return min(titles.count - 1, max(0, lroundf(p)))
    }
    
    fileprivate func animateTitleToIndex(_ index: Int) {
        for (i, label) in labels.enumerated() {
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationBeginsFromCurrentState(true)
            if i == index {
                label.center = CGPoint(x: getCenterPointForIndex(i).x, y: getCenterPointForIndex(i).y-StepSliderTitleSelectedDistance)
                label.alpha = 1.0
            } else {
                label.center = getCenterPointForIndex(i)
                label.alpha = 0.5
            }
            
            UIView.commitAnimations()
        }
    }
    
    fileprivate func animateKnobToIndex(_ index: Int) {
        var toPoint = getCenterPointForIndex(index)
        toPoint = CGPoint(x: toPoint.x-(knob.frame.size.width/2.0), y: knob.frame.origin.y)
        toPoint = fixFinalPoint(toPoint)
        
        UIView.beginAnimations(nil, context: nil)
        knob.frame = CGRect(x: toPoint.x, y: toPoint.y, width: knob.frame.size.width, height: knob.frame.size.height)
        UIView.commitAnimations()
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        //Fill Main Path
        
        context?.setFillColor("#928f9b".hexColor.cgColor)
        context?.fill(CGRect(x: StepSliderLeftOffset, y: rect.size.height / 2 - StepSliderLineHeight / 2, width: rect.size.width-StepSliderRightOffset-StepSliderLeftOffset, height: StepSliderLineHeight))
        context?.saveGState()
        for (index, _) in titles.enumerated() {
            let centerPoint = getCenterPointForIndex(index)
            //Draw Selection Circles
            context?.setFillColor(UIColor.white.cgColor)
            context?.fillEllipse(in: CGRect(x: centerPoint.x - StepSliderSelectionCirclesRadius, y: rect.size.height/2-StepSliderSelectionCirclesRadius, width: StepSliderSelectionCirclesRadius * 2, height: StepSliderSelectionCirclesRadius * 2))
        }
    }

}

extension LecStepSlider {
    func getCenterPointForIndex(_ index: Int) -> CGPoint {
        let width = CGFloat(index)/CGFloat(titles.count-1) * (self.frame.size.width-StepSliderRightOffset-StepSliderLeftOffset) + StepSliderLeftOffset
//        let height = index == 0 ? frame.size.height/2-StepSliderTitleNormalDistance : frame.size.height/2-StepSliderTitleNormalDistance
        let height = frame.size.height/2-StepSliderTitleNormalDistance
        return CGPoint(x: width, y: height)
    }
    
    func fixFinalPoint(_ point: CGPoint) -> CGPoint {
        var ptn: CGPoint = point
        if (point.x < StepSliderLeftOffset-(knob.frame.size.width/2.0)) {
            ptn.x = StepSliderLeftOffset-(knob.frame.size.width/2.0)
        } else if (point.x+(knob.frame.size.width/2.0) > self.frame.size.width-StepSliderRightOffset){
            ptn.x = self.frame.size.width-StepSliderRightOffset - (knob.frame.size.width/2.0)
        }
        return ptn
    }
}
