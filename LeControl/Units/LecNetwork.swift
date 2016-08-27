//
//  File.swift
//  LeControl
//
//  Created by 新 范 on 16/8/25.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

var httpAddress: String {
get {
    switch environment {
    case .Develop:
        return LecConstants.NetworkAddress.DevelopAddress
    case .Product:
        return LecConstants.NetworkAddress.ProductAddress
    }
}
}

protocol NetworkProtocol {
    func go(completionHandler: (NetworkResponse) -> ())
}

enum NetworkResponse {
    case Success(json: JSON)
    case Failure(error: String)
}

let FailureResponse = NetworkResponse.Failure(error: "获取数据失败")

enum Network: NetworkProtocol {
    //通用的GET POST 类型
    case GETJSON(interface: String, parameters: [String: AnyObject])
    case POSTJSON(interface: String, parameters: [String: AnyObject])
    
    //项目中用到的类型
    case POSTLogin(userName: String, password: String)
    case GETUserProjectsJSON(userId: String)
    
    func go(completionHandler: (NetworkResponse) -> ()) {
        switch self {
        case .GETJSON(let interface, let parameters):
            Alamofire.request(.GET, interface, parameters: parameters).responseJSON(completionHandler: { response in
                switch response.result {
                case .Success(let value):
                    let json = JSON(value)
                    completionHandler(NetworkResponse.Success(json: json))
                case .Failure:
                    completionHandler(FailureResponse)
                }
            })
            
        case .POSTJSON(let interface, let parameters):
            Alamofire.request(.POST, interface, parameters: parameters).responseJSON(completionHandler: { response in
                switch response.result {
                case .Success(let value):
                    let json = JSON(value)
                    completionHandler(NetworkResponse.Success(json: json))
                case .Failure:
                    completionHandler(FailureResponse)
                }
            })
            
        case .POSTLogin(let userName, let password):
            let parameters = ["userName": userName, "password": password]
            Alamofire.request(.POST, httpAddress + LecConstants.NetworkSubAddress.Login, parameters: parameters).responseJSON(completionHandler: { response in
                switch response.result {
                case .Success(let value):
                    let json = JSON(value)
                    completionHandler(NetworkResponse.Success(json: json))
                case .Failure:
                    completionHandler(FailureResponse)
                }
            })
            
        case .GETUserProjectsJSON(let userId):
            Alamofire.request(.GET, httpAddress + LecConstants.NetworkSubAddress.Userprojects2, parameters: ["userId": userId]).responseJSON(completionHandler: { response in
                switch response.result {
                case .Success(let value):
                    let json = JSON(value)
                    completionHandler(NetworkResponse.Success(json: json))
                case .Failure:
                    completionHandler(FailureResponse)
                }
            })
        }
    }
}