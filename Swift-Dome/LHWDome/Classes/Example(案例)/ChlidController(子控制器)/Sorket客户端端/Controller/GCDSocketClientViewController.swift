//
//  GCDSocketClientViewController.swift
//  LHWDome
//
//  Created by 李含文 on 2019/5/25.
//  Copyright © 2019年 李含文. All rights reserved.
//

import UIKit

class GCDSocketClientViewController: UIViewController {

    @IBOutlet weak var ipTF: UITextField!
    @IBOutlet weak var portTF: UITextField!
    @IBOutlet weak var msgTF: UITextField!
    @IBOutlet weak var logTV: UITextView!
    private var socket : GCDAsyncSocket?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupClientSocket()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    // MARK: - 创建客户端Socket
    func setupClientSocket() {
        //在主队列中处理,  所有的回执都在主队列中执行。
        self.socket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)
    }
    func showLogMsg(_ log:String) {
        logTV.text = logTV.text + "\n" + log
    }
    // MARK: - 点击了连接
    @IBAction func connectBtnClick(_ sender: Any) {
        if self.socket == nil {
            setupClientSocket()
        }
        do {
            if self.socket?.isConnected == false {
                try self.socket?.connect(toHost: ipTF.text ?? "", onPort: UInt16(portTF.text ?? "0")!)
            }
        }
        catch {
            showLogMsg("连接失败...")
            return
        }
        showLogMsg("连接成功")
        
    }
    @IBAction func sendBtnClick(_ sender: Any) {
        if let data = msgTF.text?.data(using: String.Encoding.utf8) {
            showLogMsg(String(format: "你: %@", msgTF.text ?? ""))
            self.socket?.write(data, withTimeout: 30, tag: 100)
            msgTF.text = ""
        } else {
            HWPrint("发送失败")
        }
    }
    func sendMsg(_ msg: String?) {
        if let data = msg?.data(using: String.Encoding.utf8) {
            showLogMsg(String(format: "你: %@", msgTF.text ?? ""))
            self.socket?.write(data, withTimeout: 30, tag: 100)
            msgTF.text = ""
        } else {
            HWPrint("发送失败")
        }
    }
    
}

extension GCDSocketClientViewController : GCDAsyncSocketDelegate {
   
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        let strMsg = "我是客户端 连接你来了"
        sendMsg(strMsg)
        self.socket?.readData(withTimeout: -1, tag: 100)
    }
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        showLogMsg("socket断开连接...")
    }
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        let strMsg = String(bytes: data, encoding: String.Encoding.utf8)
        let log = String(format: "服务器: %@", strMsg ?? "")
        showLogMsg(log)
        sock.readData(withTimeout: -1, tag: 100)
    }
}
