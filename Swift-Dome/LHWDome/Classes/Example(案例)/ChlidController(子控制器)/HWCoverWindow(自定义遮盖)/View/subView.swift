//
//  subView.swift
//  自定义遮盖
//
//  Created by 李含文 on 2018/8/8.
//  Copyright © 2018年 李含文. All rights reserved.
//

import UIKit

class subView: UIView {

    var buttonClickBlock:(()->())?

    @IBAction func buttonClick(_ sender: UIButton) {
        if buttonClickBlock == nil {return}
        buttonClickBlock!()
    }
}

