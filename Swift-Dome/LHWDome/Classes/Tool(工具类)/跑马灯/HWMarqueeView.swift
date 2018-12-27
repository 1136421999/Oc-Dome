//
//  HWMarqueeView.swift
//  JJMarqueePro
//
//  Created by 李含文 on 2018/12/21.
//  Copyright © 2018年 Jason. All rights reserved.
//

import UIKit

protocol HWMarqueeViewDataSource:NSObjectProtocol {
    /// MARK: - 多少条数据
    func numberOfItems(_ marqueeView:HWMarqueeView) -> Int
    /// MARK: - 每条的attributedString
    func marqueeView(_ marqueeView:HWMarqueeView, cellForItemAt index:Int) -> NSAttributedString
}
class HWMarqueeView: UIView {

    open weak var dataSource:HWMarqueeViewDataSource?
    /// 点击回调
    open var clickBlock:((Int)->())?
    /// 自动滑动时间间隔
    open var automaticSlidingInterval: CGFloat = 3 {
        didSet{
            print("时钟是\(self.automaticSlidingInterval)")
        }
    }
    /// MARK: - 记录下一个出现的角标
    private var nextIndex:Int = 0
    /// MARK: - 第一个Lab
    private let label_one = UILabel()
    /// MARK: - 第二个Lab
    private let label_two = UILabel()
    /// MARK: - 时钟
    private var timer: Timer?
    /// 用于记录数量
    private var counts = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
        self.setUpUI()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = true
        self.setUpUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setUpUI() -> Void {
        label_one.font = UIFont.systemFont(ofSize: 13)
        label_two.font = UIFont.systemFont(ofSize: 13)
        label_one.textColor = UIColor.red
        label_two.textColor = UIColor.red
        self.addSubview(label_one)
        self.addSubview(label_two)
        label_one.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        label_two.frame = CGRect.init(x: 0, y: self.frame.size.height, width: self.frame.size.width, height: self.frame.size.height)
        /// 添加点击手势
        let tapAction:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(_:)))
        self.addGestureRecognizer(tapAction)
    }
    
    @objc func tapAction(_ tap:UITapGestureRecognizer){
        if clickBlock == nil {return}
        var index = nextIndex - 1
        index = index%self.counts
        if index == -1 {
            index = counts-1
        }
        clickBlock!(index)
    }
}
extension HWMarqueeView {
    /// 结束定时
    open func cancelTimer() -> Void {
        if self.timer != nil {
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    /// 开启定时
    open func startTimer(){
        cancelTimer()
        self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(self.automaticSlidingInterval), target: self, selector: #selector(self.flipNext(_:)), userInfo: nil, repeats: true)
        if self.timer != nil {
            RunLoop.current.add(self.timer!, forMode: RunLoopMode.commonModes)
        }
    }
    /// 刷新数据源
    open func reloadData() -> Void {
        guard let _ = dataSource else {
            print("代理delegate或则数据源dataSource没有设置")
            return
        }
        counts = dataSource!.numberOfItems(self)
        guard counts > 0 else {
            print("没有需要显示的marqueeView")
            return
        }
        print("deleate and datasource set ok")
        self.initStatusMarquee(0)
    }
    /// MARK: - 先初始化第一次显示，然后等待时钟fire
    private func initStatusMarquee(_ startInx:Int) -> Void {
        nextIndex = startInx
        label_one.attributedText = dataSource!.marqueeView(self, cellForItemAt: nextIndex)
        label_one.m_y = 0
        guard counts > startInx + 1  else {
            return
        }
        //数目大于一个可以循环
        nextIndex += 1
        label_two.attributedText = dataSource!.marqueeView(self, cellForItemAt: nextIndex)
        label_two.m_y = self.bounds.size.height
        self.startTimer()
    }
    
    
    @objc private func flipNext(_ sender:Timer) {
        let oneY = self.label_one.m_y
        let twoY = self.label_two.m_y
        UIView.animate(withDuration: 0.75, animations: {
            if twoY > oneY {
                self.label_one.m_y = -self.bounds.size.height
                self.label_two.m_y = 0
            } else {
                self.label_one.m_y = 0
                self.label_two.m_y = -self.bounds.size.height
            }
            self.nextIndex = self.nextIndex + 1
            self.nextIndex = self.nextIndex%self.counts
        }) { (true) in
            let nextLabel : UILabel?
            if oneY < twoY{
                nextLabel = self.label_one
                self.label_one.m_y = self.bounds.size.height
            }else{
                nextLabel = self.label_two
                self.label_two.m_y = self.bounds.size.height
            }
            nextLabel?.attributedText = self.dataSource?.marqueeView(self, cellForItemAt: self.nextIndex)
        }
    }
}
extension UIView {
    var m_y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
}
