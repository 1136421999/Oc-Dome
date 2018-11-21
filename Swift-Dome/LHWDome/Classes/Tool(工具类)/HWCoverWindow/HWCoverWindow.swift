//
//  HWCoverView.swift
//  自定义遮盖
//
//  Created by 李含文 on 2018/8/8.
//  Copyright © 2018年 李含文. All rights reserved.
//

import UIKit

protocol HWCoverWindowDataSource : NSObjectProtocol{
    /** 设置遮盖的子控件 */
    func setupSubView(cover : HWCoverWindow)->UIView
    /** 设置遮盖的子控件Frame */
    func setupSubViewRect(cover : HWCoverWindow)->CGRect
}
class HWCoverWindow: UIWindow {
    open weak var dataSource : HWCoverWindowDataSource?
    private weak var subView :UIView? // 注意这里对subView是弱引用
    /// 黑色区域是否响应事件
    open var isBlackRegionResponse:Bool = false
    /// 黑色区域点击回调
    open var tapClickBlock:(()->())?
    /// 设置背景颜色
    open func setBackgroundColor(_ color:UIColor) {
        coverView.backgroundColor = color
    }
    /// 用于记录真实Y
    private var realY : CGFloat = 0
    override init(frame: CGRect) {
        realY = frame.origin.y
        super.init(frame: CGRect.init(x: 0, y: UIScreen.main.bounds.size.height, width: frame.size.width, height: frame.size.height))
        self.backgroundColor = UIColor.clear
        self.windowLevel = UIWindowLevelNormal// UIWindowLevelAlert + 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var coverView : UIView = { // 懒加载
        let coverView = UIView.init()
        coverView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.2)
        //        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapOne(tap:)))
        //        //通过numberOfTouchesRequired属性设置触摸点数，比如设置2表示必须两个手指触摸时才会触发
        //        tap.numberOfTapsRequired = 1
        //        //通过numberOfTapsRequired属性设置点击次数，单击设置为1，双击设置为2
        //        tap.numberOfTouchesRequired = 1
        //        coverView.addGestureRecognizer(tap)
        return coverView
    }()
    /// 显示
    open func show(){
        if self.dataSource == nil { return }
        makeKeyAndVisible()
        addSubview(coverView)
        coverView.frame = self.bounds
        setSubView()
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.frame.origin.y = self?.realY ?? 0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let window = UIApplication.shared.keyWindow
        window?.endEditing(true)
        if isBlackRegionResponse {
            let touch = touches.first
            let tapPoint = touch?.location(in: self.coverView)
            if tapPoint == nil {return}
            if subView == nil {return}
            if subView!.frame.contains(tapPoint!) == true { return } // 判断当前点是否在subView上 在就直接return
            hidden(true)
            if tapClickBlock == nil { return }
            tapClickBlock!()
        }
    }
    /// 隐藏遮盖
    open func hidden(_ animation:Bool? = nil) {
        if animation == nil {
            removeCover()
        } else {
            if animation == true {
                UIView.animate(withDuration: 0.3, animations: { [weak self] in
                    self?.frame.origin.y = UIScreen.main.bounds.size.height
                }) { [weak self](tag) in
                    self?.hidden()
                }
            } else {
                removeCover()
            }
        }
    }
    private func removeCover() {
        self.subView?.removeFromSuperview()
        self.coverView.removeFromSuperview()
        self.resignKey()
    }
    private func setSubView() {
        weak var weakSelf = self // 弱引用
        if weakSelf == nil {return}
        subView?.removeFromSuperview()
        // 将数据源返回的View添加到当前view上
        let subview = dataSource?.setupSubView(cover: weakSelf!)
        self.subView = subview
        subview?.frame = (dataSource?.setupSubViewRect(cover: weakSelf!) ?? CGRect.zero)
        coverView.addSubview(subview!)
    }
    deinit {
        print("\(type(of: self))释放")
    }
    
}
