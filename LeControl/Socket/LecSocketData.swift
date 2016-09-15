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

class LecSocketData {
    static func generatorStatusReadingByte(_ msg: StatusMessage) -> [UInt8] {
        let address = msg.address.components(separatedBy: ".")
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
    
    static func getStatusReadingData(_ cams: [LecCam]) -> Data {
        let camMessages = cams.map { StatusMessage(address: $0.statusAddress, type: $0.commandType.rawValue) }
        var bytes = [UInt8]()
        for camMessage in Set(camMessages) {
            bytes += generatorStatusReadingByte(camMessage)
        }
        return Data(bytes: UnsafePointer<UInt8>(bytes), count: bytes.count)
    }
    
    static func generatorControlByte(_ msg: ControlMessage) -> [UInt8] {
        let address = msg.address.components(separatedBy: ".")
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
    
    static func getControlData(_ cam: LecCam) -> Data {
        let msg = ControlMessage(address: cam.controlAddress, type: cam.commandType.rawValue, value: cam.controlValue)
        let bytes = generatorControlByte(msg)
        return Data(bytes: UnsafePointer<UInt8>(bytes), count: bytes.count)
    }
    
    static func addrGet(_ fs: UInt8, t: UInt8) -> String {
        let s = fs & 0x0F
        let f = (fs & 0xF0) >> 4
        return String(f)+"."+String(s)+"."+String(t)
    }
    
    static func handle(_ data: Data) {
        print(data.getBytes())
        var needAppend = false
        var code2D = [[UInt8]]()
        var tcodes = [UInt8]()
        
        for code in data.getBytes() {
            if code == LecConstants.Command.StartCode {
                needAppend = true
            }
            if needAppend {
                tcodes.append(code)
            }
            if code == LecConstants.Command.EndCode {
                code2D.append(tcodes)
                tcodes.removeAll()
            }
        }
        print(code2D)
        for camCode in code2D {
            let feedbackAddress = LecSocketData.addrGet(camCode[LecConstants.Command.FirstAndSecondAddressIndex], t: camCode[LecConstants.Command.ThirdAddressIndex])
            let statusValue = Int(camCode[LecConstants.Command.ValueIndex])
            
            if let cam = LecSocketManager.sharedSocket.dataModel.getCamByStatusAddress(feedbackAddress) {
                if cam.camType < 40 {
                    cam.statusValue = statusValue
                }
                LecSocketManager.sharedSocket.camRefreshDelegate?.refreshCam(feedbackAddress, statusValue: statusValue)
            }
        }
        
    }
}

extension Data {
    func getBytes() -> [UInt8] {
        // create buffer, this is an array of UInt8
        var array = [UInt8](repeating: 0, count: count / MemoryLayout<UInt8>.size)
        // copy bytes into array
        copyBytes(to: &array, count:count)
        return array
    }
}



