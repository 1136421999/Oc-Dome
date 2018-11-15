//
//  HWRefresh.swift
//  RxSwiftTest
//
//  Created by Hanwen on 2018/1/12.
//  Copyright © 2018年 SK丿希望. All rights reserved.
//

import Foundation
import UIKit
import MJRefresh

class HWRefresh: NSObject {
    var hearder : MJRefreshNormalHeader? = nil
    var footer : MJRefreshBackNormalFooter? = nil
    func my_heardWithRefreshingBlock( block: @escaping (() -> Void)) -> MJRefreshNormalHeader {
        hearder = MJRefreshNormalHeader {
            block()
        }
        hearder!.isAutomaticallyChangeAlpha = true  //透明度渐变
        return hearder!
    }
    func my_footerWithRefreshingBlock( block: @escaping (() -> Void)) -> MJRefreshBackNormalFooter {
        footer = MJRefreshBackNormalFooter {
            block()
        }
//        footer!.setTitle("你点点试试", for: MJRefreshState.idle) // 设置加载过程的文字
        return footer!
    }
}
