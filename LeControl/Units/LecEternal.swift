//
//  LecEnternal.swift
//  LeControl
//
//  Created by 新 范 on 16/8/30.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import Foundation


enum LecEternal {
    
    static func setObject(value: AnyObject!, forKey defaultName: String!) {
        let defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(value, forKey:defaultName)
        defaults.synchronize()
    }
    
    static func objectForKey(defaultName: String!) -> AnyObject! {
        let defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        return defaults.objectForKey(defaultName)
    }
}