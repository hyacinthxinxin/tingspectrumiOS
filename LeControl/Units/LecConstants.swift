//
//  LecConstants.swift
//  LeControl
//
//  Created by 新 范 on 16/8/23.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import Foundation
import UIKit

struct LecConstants {
    struct AppColor {
        static let CamTintColor: UIColor = "#6FFFDB".hexColor
        static let ThemeBGColor: UIColor = "#271E36".hexColor
        static let SeparatorColor = UIColor(white: 1, alpha: 0.07)
    }
    
    struct LecJSONKey {
        static let BuildingID = "id"
        static let BuildingName = "name"
        static let SocketAddress = "socket_address"
        static let SocketPort = "socket_port"
        static let FloorID = "id"
        static let FloorName = "name"
        static let FloorImageName = "image_name"
        static let AreaID = "id"
        static let AreaName = "name"
        static let AreaImageName = "image_name"
        static let DeviceID = "id"
        static let DeviceType = "i_type"
        static let DeviceName = "name"
        static let DeviceImageName = "image_name"
        static let CamID = "id"
        static let CamName = "name"
        static let CamImageName = "image_name"
        static let CamType = "i_type"
        static let ControlType = "control_type"
        static let ControlAddress = "control_address"
        static let StatusAddress = "status_address"
        static let ControlValue = "control_value"
        static let StatusValue = "status_value"
        static let MinControlValue = "min_control_value"
        static let MaxControlValue = "max_control_value"
        static let MaxStatusValue = "max_status_value"
        static let MinStatusValue = "min_status_value"
        static let IsVisible = "IsVisible"
        static let Usn = "usn"
        
        static let Building = "building"
        static let Floors = "floors"
        static let Areas = "areas"
        static let Devices = "devices"
        static let Cams = "cams"
    }
    
    struct Command {
        static let StartCode: UInt8 = 0x7A
        static let EndCode: UInt8 = 0x5A
        static let ControlCode: UInt8 = 0x40
        static let StatusCode: UInt8 = 0x41
        static let FirstAndSecondAddressIndex = 2
        static let ThirdAddressIndex = 3
        static let ValueIndex = 5
        static let TypeIndex = 4
        static let EmptyValue: UInt8 = 0x00
    }
    
    struct DeviceCellHeight {
        static let Light_Switch: CGFloat = 55
        static let LightDimming_Switch: CGFloat = 55
        static let AirConditioning_Switch: CGFloat = 55
        static let FloorHeating_Switch: CGFloat = 55
        static let FreshAir_Switch: CGFloat = 55
        static let LightDimming_Dimming: CGFloat = 94
        static let Curtain_Curtain: CGFloat = 184
        static let AirConditioning_Temperature: CGFloat = 89
        static let FloorHeating_Temperature: CGFloat = 89
        static let AirConditioning_Speed: CGFloat = 130
        static let AirConditioning_Model: CGFloat = 152
        static let FreshAir_Speed: CGFloat = 130
    }
    
    struct NotificationKey {
        static let Welcome = "kWelcomeNotif"
    }
    
    struct AddressInfo {
        static let EmptyAddress = "0/0/0"
    }
    
    struct Path {
        static let Documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        static let Library = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first!
        static let Tmp = NSTemporaryDirectory()
        static let SubDirectoryName = "UserProject"
    }
    
    struct ReuseIdentifier {
        static let AreaCell = "LecAreaCell"
        static let AreaDetailCell = "LecAreaDetailCell"
        static let BuildingCell = "LecBuildingCell"
        static let SceneCell = "LecSceneCell"
        static let DeviceCell = "LecDeviceCell"
    }
    
    struct SegueIdentifier {
        static let ShowAreaDetail = "ShowAreaDetail"
        static let ShowLogin = "ShowLogin"
        static let ShowConfig = "ShowConfig"
        static let ShowDevice = "ShowDevice"
        static let ShowScene = "ShowScene"
    }
    
    struct NetworkSubAddress {
        static let Login: String = "api/v1/auth/sign_in"
        static let Buildings = "api/v1/buildings"
        static let GetBuildingDetail = "api/v1/project"
    }
    
    struct NetworkAddress {
        static let DevelopAddress: String = "http://localhost:3000/"
        static let ProductAddress: String = "http://www.tingspectrum.com/"
    }
    
}
