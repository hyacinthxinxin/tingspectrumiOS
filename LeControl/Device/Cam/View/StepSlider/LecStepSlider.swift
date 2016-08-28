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
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        //Draw Main Cirlce
        CGContextSetFillColorWithColor(context,  LecConstants.AppColor.CamTintColor.CGColor)
        CGContextFillEllipseInRect(context,  CGRectMake(0, 0, KnobRadius * 2, KnobRadius * 2))
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
    var diffPoint: CGPoint = CGPointZero
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
        self.init(frame: CGRectZero)
        self.titles = titles
        setupLables()
    }
    
    let minimumValueImageView: UIImageView = UIImageView(image: UIImage(named: "wind_smaller"))
    let maximumValueImageView: UIImageView = UIImageView(image: UIImage(named: "wind_bigger"))

    func commonInit() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(LecStepSlider.itemSelected(_:)))
        addGestureRecognizer(tap)
        
        knob.adjustsImageWhenHighlighted = false
        knob.addTarget(self, action: #selector(LecStepSlider.touchDown(_:withEvent:)), forControlEvents: .TouchDown)
        knob.addTarget(self, action: #selector(LecStepSlider.touchUp(_:)), forControlEvents: .TouchUpInside)
        knob.addTarget(self, action: #selector(LecStepSlider.touchMove(_:withEvent:)), forControlEvents: [.TouchDragOutside, .TouchDragInside])
        addSubview(knob)
        addSubview(minimumValueImageView)
        addSubview(maximumValueImageView)
    }
    
    func setupLables() {
        for (_, title) in titles.enumerate() {
            let label = UILabel()
            label.backgroundColor = UIColor.clearColor()
            label.text = title
            label.textColor = UIColor.whiteColor()
            label.textAlignment = .Center
            label.font = UIFont.systemFontOfSize(13)
            labels += [label]
            addSubview(label)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        oneSlotSize = (frame.size.width - StepSliderLeftOffset - StepSliderRightOffset)/CGFloat(titles.count-1)
        knob.frame = CGRectMake(StepSliderLeftOffset, frame.size.height/2 - KnobRadius, KnobRadius * 2, KnobRadius * 2)
        animateKnobToIndex(selectedIndex)
        for (index, label) in labels.enumerate() {
            label.frame = CGRectMake(0, 0, oneSlotSize, 25)
            label.center = getCenterPointForIndex(index)
        }
        minimumValueImageView.center = CGPoint(x: 23, y: frame.size.height/2)
        maximumValueImageView.center = CGPoint(x: frame.size.width - 23, y: frame.size.height/2)
    }
    
    // MARK - Actions
    
    func itemSelected(tap: UITapGestureRecognizer) {
        selectedIndex = getSelectedIndexInPoint(tap.locationInView(self))
        sendActionsForControlEvents(.TouchUpInside)
        sendActionsForControlEvents(.ValueChanged)
    }
    
    func touchDown(sender: UIButton, withEvent event: UIEvent) {
        if let currentPoint = event.allTouches()?.first?.locationInView(self) {
            diffPoint = CGPointMake(currentPoint.x - sender.frame.origin.x, currentPoint.y - sender.frame.origin.y)
        }
        sendActionsForControlEvents(.TouchDown)
    }
    
    func touchUp(sender: UIButton) {
        selectedIndex = getSelectedIndexInPoint(sender.center)
        animateKnobToIndex(selectedIndex)
        sendActionsForControlEvents(.TouchUpInside)
        sendActionsForControlEvents(.ValueChanged)
    }
    
    func touchMove(sender: UIButton, withEvent event: UIEvent) {
        if let currentPoint = event.allTouches()?.first?.locationInView(self) {
            var toPoint = CGPointMake(currentPoint.x - diffPoint.x, knob.frame.origin.y)
            toPoint = fixFinalPoint(toPoint)
            knob.frame = CGRectMake(toPoint.x, toPoint.y, knob.frame.size.width, knob.frame.size.height)
        }
        
        let selected = getSelectedIndexInPoint(sender.center)
        animateTitleToIndex(selected)
        sendActionsForControlEvents(.TouchDragInside)
    }
    
    private func getSelectedIndexInPoint(point: CGPoint) -> Int {
        let p = Float((point.x - StepSliderLeftOffset)/oneSlotSize)
        return min(titles.count - 1, max(0, lroundf(p)))
    }
    
    private func animateTitleToIndex(index: Int) {
        for (i, label) in labels.enumerate() {
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationBeginsFromCurrentState(true)
            if i == index {
                label.center = CGPointMake(getCenterPointForIndex(i).x, getCenterPointForIndex(i).y-StepSliderTitleSelectedDistance)
                label.alpha = 1.0
            } else {
                label.center = getCenterPointForIndex(i)
                label.alpha = 0.5
            }
            
            UIView.commitAnimations()
        }
    }
    
    private func animateKnobToIndex(index: Int) {
        var toPoint = getCenterPointForIndex(index)
        toPoint = CGPointMake(toPoint.x-(knob.frame.size.width/2.0), knob.frame.origin.y)
        toPoint = fixFinalPoint(toPoint)
        
        UIView.beginAnimations(nil, context: nil)
        knob.frame = CGRectMake(toPoint.x, toPoint.y, knob.frame.size.width, knob.frame.size.height)
        UIView.commitAnimations()
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        //Fill Main Path
        
        CGContextSetFillColorWithColor(context, "#928f9b".hexColor.CGColor)
        CGContextFillRect(context, CGRectMake(StepSliderLeftOffset, rect.size.height / 2 - StepSliderLineHeight / 2, rect.size.width-StepSliderRightOffset-StepSliderLeftOffset, StepSliderLineHeight))
        CGContextSaveGState(context)
        for (index, _) in titles.enumerate() {
            let centerPoint = getCenterPointForIndex(index)
            //Draw Selection Circles
            CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
            CGContextFillEllipseInRect(context, CGRectMake(centerPoint.x - StepSliderSelectionCirclesRadius, rect.size.height/2-StepSliderSelectionCirclesRadius, StepSliderSelectionCirclesRadius * 2, StepSliderSelectionCirclesRadius * 2))
        }
    }

}

extension LecStepSlider {
    func getCenterPointForIndex(index: Int) -> CGPoint {
        let width = CGFloat(index)/CGFloat(titles.count-1) * (self.frame.size.width-StepSliderRightOffset-StepSliderLeftOffset) + StepSliderLeftOffset
//        let height = index == 0 ? frame.size.height/2-StepSliderTitleNormalDistance : frame.size.height/2-StepSliderTitleNormalDistance
        let height = frame.size.height/2-StepSliderTitleNormalDistance
        return CGPointMake(width, height)
    }
    
    func fixFinalPoint(point: CGPoint) -> CGPoint {
        var ptn: CGPoint = point
        if (point.x < StepSliderLeftOffset-(knob.frame.size.width/2.0)) {
            ptn.x = StepSliderLeftOffset-(knob.frame.size.width/2.0)
        } else if (point.x+(knob.frame.size.width/2.0) > self.frame.size.width-StepSliderRightOffset){
            ptn.x = self.frame.size.width-StepSliderRightOffset - (knob.frame.size.width/2.0)
        }
        return ptn
    }
}
