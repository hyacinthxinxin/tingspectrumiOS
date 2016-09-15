//
//  LecSocketManager.swift
//  LeControl
//
//  Created by 新 范 on 16/8/23.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import Foundation
import CocoaAsyncSocket
import JDStatusBarNotification

protocol LecCamRefreshDelegate: class {
    func refreshCam(_ feedbackAddress: String, statusValue: Int)
}

class LecSocketManager: NSObject {
    static let sharedSocket = LecSocketManager()
    
    var dataModel: LecDataModel!
    fileprivate var socket = GCDAsyncSocket()
    var socketInfo: (address: String, port: UInt16) = ("", 0)
    weak var camRefreshDelegate: LecCamRefreshDelegate?
    var isErrorNotificationShowed = false

    override init() {
        super.init()
        dataModel = LecDataModel()
        socket.delegate = self
        socket.delegateQueue = DispatchQueue.main
    }
    
    func startConnectHost() {
        //Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(LecSocketManager.connectHost), userInfo: nil, repeats: true)
    }
    
    // 声明断开连接方法,断开socket连接
    private func cutOffSocket() {
        socket.disconnect()
    }
    
    // socket连接
    @objc private func connectHost() {
        guard !socket.isConnected else { return }
        cutOffSocket()
        socketInfo.address = dataModel.building.socketAddress
        //socketInfo.address = "192.168.100.9"
        socketInfo.port = dataModel.building.socketPort
        //socketInfo.port = 4196
        do {
            try socket.connect(toHost: socketInfo.address, onPort: socketInfo.port)
        } catch let error {
            print("error in connecting" + String(describing: error))
        }
    }
    
    //刚进入控制界面，读取具有反馈的设备的状态
    func sendStatusReadingMessageWithCams(_ cams: [LecCam]) {
        writeData(LecSocketData.getStatusReadingData(cams))
    }
    
    //发送控制命令
    func sendMessageWithCam(_ cam: LecCam) {
        guard cam.controlAddress != LecConstants.AddressInfo.EmptyAddress else { return }
        writeData(LecSocketData.getControlData(cam))
    }
    
    fileprivate func writeData(_ data: Data) {
        socket.write(data, withTimeout: -1, tag: 0)
    }
}

extension LecSocketManager: GCDAsyncSocketDelegate {
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        print(#function)
        let msg = "已连接上服务端，（地址: " + host + "）"
        print(msg)
        isErrorNotificationShowed = false
        JDStatusBarNotification.show(withStatus: msg, dismissAfter: 2.0, styleName: JDStatusBarStyleSuccess);
        sock.readData(withTimeout: -1, tag: 0)
    }
    
    func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
        print(#function)
        sock.readData(withTimeout: -1, tag: 0)
    }
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        print(#function)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        LecSocketData.handle(data)
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        sock.readData(withTimeout: -1, tag: 0)
    }
    
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        print(#function)
        let msg = "连接服务端（地址: " + socketInfo.address + "）失败，请检查设置"
        print(msg)
        if !isErrorNotificationShowed {
            JDStatusBarNotification.show(withStatus: msg, dismissAfter: 3.0, styleName: JDStatusBarStyleError);
            isErrorNotificationShowed = true
        }
    }
}
