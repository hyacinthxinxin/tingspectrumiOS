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
func delay(seconds: Double, completion:@escaping ()->()) {
    let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds )) / Double(NSEC_PER_SEC)
    
    DispatchQueue.main.asyncAfter(deadline: popTime) {
        completion()
    }
}
