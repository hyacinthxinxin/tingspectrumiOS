//
//  LecSocketManager.swift
//  LeControl
//
//  Created by 新 范 on 16/8/23.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import Foundation
import CocoaAsyncSocket
import Whisper

protocol LecCamRefreshDelegate: class {
    func refreshCam(feedbackAddress: String, statusValue: Int)
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
        socketInfo.address = dataModel.building.socketAddress
        socketInfo.port = dataModel.building.socketPort
        do {
            try socket.connectToHost(socketInfo.address, onPort: socketInfo.port)
        } catch let error {
            print("error in connecting" + String(error))
        }
    }
    
    //刚进入控制界面，读取具有反馈的设备的状态
    func sendStatusReadingMessageWithCams(cams: [LecCam]) {
        writeData(LecSocketData.getStatusReadingData(cams))
    }
    
    //发送控制命令
    func sendMessageWithCam(cam: LecCam) {
        guard cam.controlAddress != LecConstants.AddressInfo.EmptyAddress else { return }
        writeData(LecSocketData.getControlData(cam))
    }
    
    private func writeData(data: NSData) {
        socket.writeData(data, withTimeout: -1, tag: 0)
    }
    
    var errorShowed = false
}

extension LecSocketManager: AsyncSocketDelegate {
    
    func onSocket(sock: AsyncSocket!, didConnectToHost host: String!, port: UInt16) {
        let msg = "已连接上服务端，（地址: " + host + "）"
        print(msg)
        errorShowed = false
        Whistle(Murmur(title: msg, backgroundColor: LecConstants.AppColor.CamTintColor), action: .Show(1.5))
        
        if let _ = UIApplication.sharedApplication().delegate {
 
        }
        sock.readDataWithTimeout(-1, tag: 0)
    }
    
    func onSocket(sock: AsyncSocket!, didWriteDataWithTag tag: Int) {
        print(#function)
        sock.readDataWithTimeout(-1, tag: 0)
    }
    
    func onSocket(sock: AsyncSocket!, didReadData data: NSData!, withTag tag: Int) {
        print(#function)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        LecSocketData.handle(data)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        sock.readDataWithTimeout(-1, tag: 0)
    }
    
    func onSocket(sock: AsyncSocket!, willDisconnectWithError err: NSError!) {
        let msg = "连接服务端（地址: " + socketInfo.address + "）失败，请检查设置"
        print(msg)
        if !errorShowed {
            Whistle(Murmur(title: msg, backgroundColor: UIColor.redColor()), action: .Show(3.0))
            errorShowed = true
        }

        performSelector(#selector(connectHost), withObject: nil, afterDelay: 1.0, inModes: [NSRunLoopCommonModes])
    }
    
    func onSocketDidDisconnect(sock: AsyncSocket!) {
        print(#function)
    }
}
