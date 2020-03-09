//
//  HWNoDataView.swift
//  WHYG
//
//  Created by Hanwen on 2018/5/27.
//  Copyright © 2018年 东莞市三心网络科技有限公司. All rights reserved.
//

import UIKit

class HWNoDataView: UIView {

    /// 缺失图片
    @IBOutlet weak var iconImageView: UIImageView!
    /// 缺失文字
    @IBOutlet weak var titleLabel: UILabel!
    /// 按钮 默认隐藏
    @IBOutlet weak var button: UIButton!
    /// 按钮点击回调
    var buttonClickBlcok:(()->())?
    class func noDataView(image:UIImage?, title:String?)->HWNoDataView{
        let nibView = Bundle.main.loadNibNamed("HWNoDataView", owner: nil, options: nil)
        if let view = nibView?.first as? HWNoDataView{
            view.iconImageView.image = image ?? hw_Image(named: "没数据缺省页")
            view.titleLabel.text = title ?? "暂无数据"
            return view
        }
        return HWNoDataView()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        button.addRounded()
        button.isHidden = true
        button.backgroundColor = HWMainColor()
    }
    @IBAction func buttonClick(_ btn: UIButton) {
        if buttonClickBlcok == nil {return}
        buttonClickBlcok!()
    }
    
    
}
