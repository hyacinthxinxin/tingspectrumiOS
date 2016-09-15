//
//  LecEnternal.swift
//  LeControl
//
//  Created by 新 范 on 16/8/30.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import Foundation


enum LecEternal {
    
    static func setObject(_ value: AnyObject!, forKey defaultName: String!) {
        let defaults:UserDefaults = UserDefaults.standard
        defaults.set(value, forKey:defaultName)
        defaults.synchronize()
    }
    
    static func objectForKey(_ defaultName: String!) -> AnyObject! {
        let defaults:UserDefaults = UserDefaults.standard
        return defaults.object(forKey: defaultName) as AnyObject!
    }
}
