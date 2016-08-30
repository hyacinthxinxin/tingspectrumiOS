//
//  SocketData.swift
//  LeControl
//
//  Created by 新 范 on 16/8/30.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import Foundation

func == (lhs: StatusMessage, rhs: StatusMessage) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

func == (lhs: ControlMessage, rhs: ControlMessage) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

struct StatusMessage: Hashable {
    var address: String = ""
    var type = 0
    var hashValue: Int {
        get {
            return address.hashValue ^ type.hashValue
        }
    }
}

struct ControlMessage: Hashable {
    var address: String = ""
    var type = 0
    var value = 0
    var hashValue: Int {
        get {
            return address.hashValue ^ type.hashValue ^ value.hashValue
        }
    }
}

class SocketData {
    static func generatorStatusReadingByte(msg: StatusMessage) -> [UInt8] {
        let address = msg.address.componentsSeparatedByString(".")
        let type = msg.type
        
        if let firstAddress = UInt8(address[0]), let secondAddress = UInt8(address[1]), let thirdAddress = UInt8(address[2]) {
            let firstAndSecondAddress = firstAddress &* 0x10 &+ secondAddress
            return [LecConstants.Command.StartCode,
                    LecConstants.Command.StatusCode,
                    firstAndSecondAddress,
                    thirdAddress,
                    UInt8(type),
                    LecConstants.Command.EmptyValue,
                    LecConstants.Command.EndCode
            ]
        }
        return [UInt8]()
    }
    
    static func getStatusReadingData(cams: [LecCam]) -> NSData {
        let camMessages = cams.map { StatusMessage(address: $0.statusAddress, type: $0.commandType.rawValue) }
        var bytes = [UInt8]()
        for camMessage in Set(camMessages) {
            bytes += generatorStatusReadingByte(camMessage)
        }
        return NSData(bytes: bytes, length: bytes.count)
    }
    
    static func generatorControlByte(msg: ControlMessage) -> [UInt8] {
        let address = msg.address.componentsSeparatedByString(".")
        let type = msg.type
        let value = msg.value
        
        if let firstAddress = UInt8(address[0]), let secondAddress = UInt8(address[1]), let thirdAddress = UInt8(address[2]) {
            let firstAndSecondAddress = firstAddress &* 0x10 &+ secondAddress
            let lrc: UInt8 = ~(LecConstants.Command.StartCode &+  LecConstants.Command.ControlCode &+ firstAndSecondAddress &+ thirdAddress &+ UInt8(value)) &+ UInt8(type)  &+ 1
            return [LecConstants.Command.StartCode,
                    LecConstants.Command.ControlCode,
                    firstAndSecondAddress,
                    thirdAddress,
                    UInt8(type),
                    UInt8(value),
                    lrc,
                    LecConstants.Command.EndCode
                ]
        }
        return [UInt8]()
    }
    
    static func getControlData(cam: LecCam) -> NSData {
        let msg = ControlMessage(address: cam.controlAddress, type: cam.commandType.rawValue, value: cam.controlValue)
        let bytes = generatorControlByte(msg)
        return NSData(bytes: bytes, length: bytes.count)
    }
}

extension NSData {
    func getBytes() -> [UInt8] {
        // create buffer, this is an array of UInt8
        var array = [UInt8](count: length / sizeof(UInt8), repeatedValue: 0)
        // copy bytes into array
        getBytes(&array, length:length)
        return array
    }
}

