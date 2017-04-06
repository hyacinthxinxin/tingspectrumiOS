//
//  LecCookies.swift
//  LeControl
//
//  Created by 范新 on 2017/3/1.
//  Copyright © 2017年 TingSpectrum. All rights reserved.
//

import Foundation

class LecUser: NSObject {
    var name = ""
    var nickname = ""
    var image = ""
    var email = ""
    var password = ""
}

class LecHeader: NSObject {
    /*
     Access-Token:   NyUIH_nI3vsKkNFtu3hmOA
     Client:         R9H84prlUIrrYPXr4iKuDQ
     Expiry:         1438378648
     Token-Type:     Bearer
     UID:            matthughes.tech@gmail.com
    *****/
    var accessToken = ""
    var client = ""
    var expiry = 0
    var tokenType = ""
    var uid = ""
    
}

class LecCookies: NSObject {
    static let sharedCookies = LecCookies()
    
    var user: LecUser = LecUser()
    var header: LecHeader = LecHeader()

}
