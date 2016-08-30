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
    func cutOffSocket() {
        socket.disconnect()
    }
    
    // socket连接
    func connectHost() {
        cutOffSocket()
        //测试用的
        socketInfo.address = "192.168.100.7"
        do {
            try socket.connectToHost(socketInfo.address, onPort: socketInfo.port)
        } catch let error {
            print("error in connecting" + String(error))
        }
    }
    
    //刚进入控制界面，读取具有反馈的设备的状态
    func sendStatusReadingMessageWithCams(cams: [LecCam]) {
        writeData(SocketData.getStatusReadingData(cams))
    }
    
    //发送控制命令
    func sendMessageWithCam(cam: LecCam) {
        writeData(SocketData.getControlData(cam))
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
        print(data.getBytes())
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
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
            let feedbackAddress = addrGet(camCode[LecConstants.Command.FirstAndSecondAddressIndex], t: camCode[LecConstants.Command.ThirdAddressIndex])
            let statusValue = Int(camCode[LecConstants.Command.ValueIndex])
            
            if let cam = dataModel.getCamByStatusAddress(feedbackAddress) {
                if cam.camType < 40 {
                    cam.statusValue = statusValue
                }
                camRefreshDelegate?.refreshCam(feedbackAddress, statusValue: statusValue)
            }
        }

        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        sock.readDataWithTimeout(-1, tag: 0)
    }
    
    func onSocket(sock: AsyncSocket!, willDisconnectWithError err: NSError!) {
        print(#function)
        performSelector(#selector(connectHost), withObject: nil, afterDelay: 1.0, inModes: [NSRunLoopCommonModes])
    }
    
    func onSocketDidDisconnect(sock: AsyncSocket!) {
        print(#function)
    }
}
