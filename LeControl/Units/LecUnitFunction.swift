//
//  LecUnitFunction.swift
//  LeControl
//
//  Created by 新 范 on 16/8/31.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import Foundation
//
// Util delay function
//
func delay(seconds seconds: Double, completion:()->()) {
    let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * seconds ))
    
    dispatch_after(popTime, dispatch_get_main_queue()) {
        completion()
    }
}
