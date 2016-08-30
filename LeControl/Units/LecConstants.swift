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
    }
    
    struct LecJSONKey {
        static let BuildingId = "BuildingId"
        static let BuildingName = "BuildingName"
        static let IpAddress = "IpAddress"
        static let IpPort = "IpPort"
        static let FloorId = "FloorId"
        static let FloorName = "FloorName"
        static let AreaId = "AreaId"
        static let AreaName = "AreaName"
        static let AreaImageName = "AreaImageName"
        static let DeviceId = "DeviceId"
        static let DeviceType = "DeviceType"
        static let DeviceName = "DeviceName"
        static let CamId = "CamId"
        static let CamType = "CamType"
        static let SubCamType = "SubCamType"
        static let CamName = "CamName"
        static let CommandType = "ControlType"
        static let ControlAddress = "ControlAddress"
        static let StatusAddress = "StatusAddress"
        static let ControlValue = "ControlValue"
        static let MinControlValue = "MinControlValue"
        static let MaxControlValue = "MaxControlValue"
        static let StatusValue = "StatusValue"
        static let MaxStatusValue = "MaxStatusValue"
        static let MinStatusValue = "MinStatusValue"
        static let IsVisible = "IsVisible"
        static let Usn = "Usn"
        
        static let Buildings = "Buildings"
        static let Floors = "Floors"
        static let Areas = "Areas"
        static let Devices = "Devices"
        static let Cams = "Cams"
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
        static let EmptyAddress = "0.0.0"
    }
    
    struct Path {
        static let Documents = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
        static let Library = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true).first!
        static let Tmp = NSTemporaryDirectory()
    }
    
    struct ReuseIdentifier {
        static let AreaCell = "LecAreaCell"
        static let AreaDetailCell = "LecAreaDetailCell"
        static let BuildingCell = "LecBuildingCell"
        static let SceneCell = "LecSceneCell"
        static let DeviceCell = "LecDeviceCell"

        static let LightCell = "LecLightCell"
        static let LightDimmingCell = "LecLightDimmingCell"
        static let CurtainCell = "LecCurtainCell"
        static let AirConditioningCell = "LecAirConditioningCell"
        static let FloorHeatingCell = "LecFloorHeatingCell"
        
        /*
        static let DeviceTypeCell = "DeviceTypeCell"
 */
    }
    
    struct SegueIdentifier {
        static let ShowAreaDetail = "ShowAreaDetail"
        static let ShowLogin = "ShowLogin"
        static let ShowConfig = "ShowConfig"
        static let ShowDevice = "ShowDevice"
        static let ShowScene = "ShowScene"

        /*
        static let ShowDeviceList = "ShowDeviceList"
 */
    }
    
    struct NetworkSubAddress {
        static let Login = "api/login"
        static let Userprojects = "api/userprojects"
        static let Userprojects2 = "api/userprojects2"
    }
    
    struct NetworkAddress {
        static let DevelopAddress = "http://localhost:9000/"
        static let ProductAddress = "http://www.tingspectrum.com/"
    }
    
}