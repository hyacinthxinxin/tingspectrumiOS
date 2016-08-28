//
//  LecSocketManager.swift
//  LeControl
//
//  Created by 新 范 on 16/8/23.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

protocol LecCamRefreshDelegate: class {
    func refreshCam(feedbackAddress: String, statusValue: Int)
}

func addrGet(fs: UInt8, t: UInt8) -> String {
    let s = fs & 0x0F
    let f = (fs & 0xF0) >> 4
    return String(f)+"."+String(s)+"."+String(t)
}

class LecSocketManager: NSObject {
    
    static let sharedSocket = LecSocketManager()
    
    var socketInfo: (address: String, port: UInt16) = ("", 0)
    var dataModel: LecDataModel!

    private var socket = AsyncSocket()
    weak var camRefreshDelegate: LecCamRefreshDelegate?
    
    override init() {
        super.init()
        dataModel = LecDataModel()
        socketInfo.address = dataModel.building.socketAddress
        socketInfo.port = dataModel.building.socketPort
        socket.setDelegate(self)
        socket.setRunLoopModes([NSRunLoopCommonModes])
    }
    
    // 声明断开连接方法,断开socket连接
    internal func cutOffSocket() {
        socket.disconnect()
    }
    
    // socket连接
    internal func connectHost() {
        //        socket.setUserData(SocketOffline.ByUser.rawValue)
        cutOffSocket()
        
        //测试用的
        socketInfo.address = "192.168.100.11"
        
        do {
            try socket.connectToHost(socketInfo.address, onPort: socketInfo.port)
        } catch let error {
            print("error in connecting" + String(error))
        }
    }
    
    internal func sendTestMessage() {
        sendMessage("1.0.5", commandType: .Type1bit, controlValue: 0)
    }
    
    internal func sendMessageWithCam(cam: LecCam) {
        sendMessage(cam.controlAddress, commandType: cam.commandType, controlValue: cam.controlValue)
    }
    
    internal func sendMessage(controlAddress: String, commandType: LecCommand, controlValue: Int) {
        var sendData = NSData()
        let addresses = controlAddress.componentsSeparatedByString(".")
        
        if let firstAddress = UInt8(addresses[0]), let secondAddress = UInt8(addresses[1]), let thirdAddress = UInt8(addresses[2]) {
            let firstAndSecondAddress = firstAddress &* 0x10 &+ secondAddress
            let lrc: UInt8 = ~(0x7A &+  0x40 &+ firstAndSecondAddress &+ thirdAddress &+ UInt8(controlValue)) &+ UInt8(commandType.rawValue)  &+ 1
            let byteArr: [UInt8] = [0x7A, 0x40, firstAndSecondAddress, thirdAddress, UInt8(commandType.rawValue), UInt8(controlValue), lrc, 0x5A]
            sendData = NSData(bytes: byteArr, length: byteArr.count)
        }
        writeData(sendData)
    }
    
    private func writeData(data: NSData) {
        socket.writeData(data, withTimeout: -1, tag: 0)
    }
}

extension LecSocketManager: AsyncSocketDelegate {
    
    func onSocket(sock: AsyncSocket!, didConnectToHost host: String!, port: UInt16) {
        print(#function,"已连接上服务端,IP:",host,"Port:",port)
        sock.readDataWithTimeout(-1, tag: 0)
    }
    
    func onSocket(sock: AsyncSocket!, didWriteDataWithTag tag: Int) {
        print(#function)
        sock.readDataWithTimeout(-1, tag: 0)
    }
    
    func onSocket(sock: AsyncSocket!, didReadData data: NSData!, withTag tag: Int) {
        print(#function)
        print(data.getByteArray())
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        var needAppend = false
        var code2D = [[UInt8]]()
        var tcodes = [UInt8]()
        
        for code in data.getByteArray() {
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
            let st = addrGet(camCode[LecConstants.Command.FirstAndSecondAddressIndex], t: camCode[LecConstants.Command.ThirdAddressIndex])
            dataModel.getCamByStatusAddress(st)?.statusValue = Int(camCode[LecConstants.Command.ValueIndex])
        }
        camRefreshDelegate?.refreshCam("", statusValue: 1)

        UIApplication.sharedApplication().networkActivityIndicatorVisible = false

        sock.readDataWithTimeout(-1, tag: 0)
    }
    
    func onSocket(sock: AsyncSocket!, willDisconnectWithError err: NSError!) {
        print(#function)
        performSelector(#selector(connectHost), withObject: nil, afterDelay: 3.0, inModes: [NSRunLoopCommonModes])
    }
    
    func onSocketDidDisconnect(sock: AsyncSocket!) {
        
    }
    
}

extension NSData {
    func getByteArray() -> [UInt8] {
        // create buffer, this is an array of UInt8
        var array = [UInt8](count: length / sizeof(UInt8), repeatedValue: 0)
        // copy bytes into array
        getBytes(&array, length:length)
        return array
    }
}
