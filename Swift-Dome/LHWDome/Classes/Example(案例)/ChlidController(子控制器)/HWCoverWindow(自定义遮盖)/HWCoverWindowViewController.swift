//
//  HWCoverWindowViewController.swift
//  LHWDome
//
//  Created by 李含文 on 2018/11/21.
//  Copyright © 2018年 李含文. All rights reserved.
//

import UIKit

class HWCoverWindowViewController: UIViewController {
    // 定义属性
    let cover = HWCoverWindow.init(frame: CGRect.init(x: 0, y: 120, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height-120))
    override func viewDidLoad() {
        super.viewDidLoad()
        hw_setTitle("自定义遮盖")
        hw_setBgColor()
        // 成功代理
        cover.dataSource = self
        // 遮盖区域是否相应手势
        cover.isBlackRegionResponse = true
        /// 修改遮盖颜色
        cover.setBackgroundColor(UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5))
    }
    var tag = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 显示遮盖
        tag = !tag
        cover.show()
    }

}
// 数据源方法
extension HWCoverWindowViewController : HWCoverWindowDataSource {
    // 返回View
    func setupSubView(cover: HWCoverWindow) -> UIView {
        if tag == false {
            let view = subView.hw_loadViewFromNib() as! subView
            view.backgroundColor = UIColor.red
            view.buttonClickBlock = {
                cover.hidden(true)
            }
            return view
        } else {
            let view = UIView()
            view.backgroundColor = UIColor.yellow
            return view
        }
    }
    // 返回Frame
    func setupSubViewRect(cover: HWCoverWindow) -> CGRect {
        return CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width)
    }
}
