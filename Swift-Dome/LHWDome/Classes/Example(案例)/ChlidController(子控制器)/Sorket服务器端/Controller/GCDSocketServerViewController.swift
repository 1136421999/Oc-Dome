//
//  GCDSocketServerViewController.swift
//  LHWDome
//
//  Created by 李含文 on 2019/5/25.
//  Copyright © 2019年 李含文. All rights reserved.
//

import UIKit
import SystemConfiguration


class GCDSocketServerViewController: BaseViewController {
    @IBOutlet weak var portTF: UITextField!
    @IBOutlet weak var msgTF: UITextField!
    @IBOutlet weak var logTV: UITextView!
    @IBOutlet weak var ipLabel: UILabel!
    /// 服务器
    private var serverSocket : GCDAsyncSocket?
    /// 客户端
    private var clientSocket : GCDAsyncSocket?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HWPrint("路由器IP:\(HWWIFITools.hw_getRouterIP())")
        let ip = HWWIFITools.hw_getCurrentIP() ?? ""
        let name = HWWIFITools.hw_getCurreWiFiSsid() ?? ""
        ipLabel.text = "WIFI名:\(name) ip:\(ip)"
        HWPrint(name + ip)
        let hotSpotsip = HWWIFITools.hw_getHotSpotsType() ?? ""
        if hotSpotsip.count == 0 {
            HWPrint("热点关闭")
        } else {
            let name = UIDevice.current.name //设备名称
            HWPrint("热点开启")
            ipLabel.text = "WIFI名:\(name) ip:\(hotSpotsip)"
        }
        
        setupServerSocket()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    // MARK: - 创建服务器Socket
    func setupServerSocket() {
        self.serverSocket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)
    }
    
    func showLogMsg(_ log:String) {
        logTV.text = logTV.text + "\n" + log
    }
    // MARK: - 监听按钮点击
    @IBAction func listeningBtnClick(_ sender: Any) {
        do {
            try self.serverSocket?.accept(onPort: UInt16(self.portTF.text ?? "")!)
        }
        catch {
            HWPrint("监听出错")
            return
        }
        showLogMsg("正在监听...")
    }
    
    @IBAction func sendBtnClick(_ sender: Any) {
        if let data = msgTF.text?.data(using: String.Encoding.utf8) {
            showLogMsg(String(format: "你: %@", msgTF.text ?? ""))
            self.clientSocket?.write(data, withTimeout: -1, tag: 0)
            msgTF.text = ""
        } else {
            HWPrint("发送失败")
        }
    }
    
    
//    func getIFAddresses() -> [String] {
//        var addresses = [String]()
//        // Get list of all interfaces on the local machine:
//        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
//        if getifaddrs(&ifaddr) == 0 {
//            var ptr = ifaddr
//            while ptr != nil {
//                let flags = Int32((ptr?.pointee.ifa_flags)!)
//                var addr = ptr?.pointee.ifa_addr.pointee
//                HWPrint(addr)
//                // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
//                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
//                    if addr?.sa_family == UInt8(AF_INET) || addr?.sa_family == UInt8(AF_INET6) {
//                        // Convert interface address to a human readable string:
//                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
//                        if (getnameinfo(&addr!, socklen_t((addr?.sa_len)!), &hostname, socklen_t(hostname.count),
//                                        nil, socklen_t(0), NI_NUMERICHOST) == 0) {
//                            if let address = String(validatingUTF8: hostname) {
//                                addresses.append(address)
//                            }
//                        }
//                    }
//                }
//                ptr = ptr?.pointee.ifa_next
//            }
//            freeifaddrs(ifaddr)
//        }
//        print("Local IP \(addresses)")
//        return addresses
//    }
}

extension GCDSocketServerViewController : GCDAsyncSocketDelegate {
    //接收到请求
    func socket(_ sock: GCDAsyncSocket, didAcceptNewSocket newSocket: GCDAsyncSocket) {
        showLogMsg("收到客服点连接.....")
        let ip = newSocket.connectedHost ?? ""
        let port = newSocket.connectedPort
        let log = String(format: "客户端地址:%@ 端口:%d", ip, port)
        showLogMsg(log)
        self.clientSocket = newSocket
        newSocket.readData(withTimeout: -1, tag: 0)
        if let data = "你连接成功了,大兄弟".data(using: String.Encoding.utf8) {
            self.clientSocket?.write(data, withTimeout: -1, tag: 0)
            showLogMsg("你连接成功了,大兄弟")
        }
    }
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        let strMsg = String(bytes: data, encoding: String.Encoding.utf8)
        let log = String(format: "客户端: %@", strMsg ?? "")
        showLogMsg(log)
        sock.readData(withTimeout: -1, tag: 0)
    }
    
}
