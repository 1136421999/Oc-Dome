//
//  LocationViewController.swift
//  LHWDome
//
//  Created by 李含文 on 2019/1/22.
//  Copyright © 2019年 李含文. All rights reserved.
//

import UIKit

class LocationViewController: BaseViewController {

    @IBOutlet weak var editorTV: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    var page = 0
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        page += 1
        editorTV.unmarkText()
        let index: Int = self.editorTV.text?.count ?? 0
        let insertString = String(format: "@%ld ", page)
        var string = self.editorTV.text
        string?.append(contentsOf: insertString)
        self.editorTV.becomeFirstResponder()
        self.editorTV.text = string
        self.editorTV.selectedRange = NSRange(location: index + insertString.count, length: 0)
//        HWLocationManage.hw_getLocation("宝安机场") { [weak self] (item) in
//            self?.editorTV.text = "经度:\(item?.latitude)\n纬度:\(item?.longitude)\n国家:\(item?.country)\n省:\(item?.province)\n市:\(item?.city)\n区:\(item?.area)\n街道:\(item?.thoroughfare)\n详细地址:\(item?.address)"
//        }
        
//        HWLocationManage.hw_getCurrentLocatio { [weak self] (item) in
//            self?.editorTV.text = "经度:\(item?.latitude)\n纬度:\(item?.longitude)\n国家:\(item?.country)\n省:\(item?.province)\n市:\(item?.city)\n区:\(item?.area)\n街道:\(item?.thoroughfare)\n详细地址:\(item?.address)"
//        }
//        HWLocationManage.hw_getLocation(22.628345671203345, 113.81956463651879) { [weak self] (item) in
//            self?.editorTV.text = "经度:\(item?.latitude)\n纬度:\(item?.longitude)\n国家:\(item?.country)\n省:\(item?.province)\n市:\(item?.city)\n区:\(item?.area)\n街道:\(item?.thoroughfare)\n详细地址:\(item?.address)"
//        }
    }

}
