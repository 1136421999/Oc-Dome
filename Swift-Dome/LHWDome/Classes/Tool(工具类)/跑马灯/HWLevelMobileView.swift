//
//  HWLevelMobileView.swift
//  走马灯
//
//  Created by 李含文 on 2019/1/17.
//  Copyright © 2019年 SK丿希望. All rights reserved.
//

/// 文字滚动跑马灯

import UIKit


class HWLevelMobileView: UIView {
    
    private let xMargin: CGFloat = 50 /// 前后间距
    /// 时间
    private var time: Double = 10
    private var isRun: Bool = false
    private var isSuspend: Bool = false
    
    private let frontLabel = UILabel()
    private let behindLabel = UILabel()
    
    
    open var font : CGFloat = 14 {
        didSet {
            frontLabel.font = UIFont.systemFont(ofSize: font)
            behindLabel.font = UIFont.systemFont(ofSize: font)
        }
    }
    
    open var textColor = UIColor.black {
        didSet {
            frontLabel.textColor = textColor
            behindLabel.textColor = textColor
        }
    }
    
    override func awakeFromNib() {
        super .awakeFromNib()
        setUI()
    }
    func setUI() {
        self.clipsToBounds = true
        frontLabel.font = UIFont.systemFont(ofSize: font)
        behindLabel.font = UIFont.systemFont(ofSize: font)
        frontLabel.textColor = textColor
        behindLabel.textColor = textColor
        self.addSubview(frontLabel)
        self.addSubview(behindLabel)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    // MARK: - 开始跑马灯动画
    func start(){
        if isRun == false {
            isRun = true
            isSuspend = false
            frontLabel.layer.timeOffset = 0.0
            behindLabel.layer.timeOffset = 0.0
            frontLabel.layer.speed = 1.0
            behindLabel.layer.speed = 1.0
            frontLabel.layer.beginTime = 0.0
            behindLabel.layer.beginTime = 0.0
            marqueeAnimation()
        }
    }
    
    // MARK: - 停止跑马灯动画
    func stop() {
        if isRun {
            isRun = false
            frontLabel.layer.removeAnimation(forKey: "frontAnima")
            behindLabel.layer.removeAnimation(forKey: "behindAnima")
        }
    }
    
    // MARK: -  暂停动画
    func suspend() {
        if isRun && isSuspend == false {
            isSuspend = true
            let frontPauseTime = frontLabel.layer.convertTime(CACurrentMediaTime(), from: nil)
            frontLabel.layer.speed = 0.0
            frontLabel.layer.timeOffset = frontPauseTime
            
            let behindPauseTime = behindLabel.layer.convertTime(CACurrentMediaTime(), from: nil)
            behindLabel.layer.speed = 0.0
            behindLabel.layer.timeOffset = behindPauseTime
        }
    }
    
    // MARK: - 继续动画
    func continuation() {
        if isRun && isSuspend {
            isSuspend = false
            let frontPauseTime = frontLabel.layer.timeOffset
            frontLabel.layer.speed = 1.0
            frontLabel.layer.timeOffset = 0.0
            frontLabel.layer.beginTime = 0.0
            let frontTimeSincePause = frontLabel.layer.convertTime(CACurrentMediaTime(), from: nil)  - frontPauseTime
            frontLabel.layer.beginTime = frontTimeSincePause
            
            let behindPauseTime = behindLabel.layer.timeOffset
            behindLabel.layer.speed = 1.0
            behindLabel.layer.timeOffset = 0.0
            behindLabel.layer.beginTime = 0.0
            let behindTimeSincePause = behindLabel.layer.convertTime(CACurrentMediaTime(), from: nil)  - behindPauseTime
            behindLabel.layer.beginTime = behindTimeSincePause
            
        }
    }
    private var _content : String?
    // MARK: - 设置显示文字
    open var content : String? {
        set {
            _content = newValue
            if (newValue ?? "").count == 0 {return}
            stop()
            time = Double((newValue!.count)/5)
            frontLabel.text = newValue
            frontLabel.sizeToFit()
            frontLabel.frame.size.width = frontLabel.frame.width + xMargin
            frontLabel.center.y = self.frame.height / 2
            frontLabel.frame.origin.x = 0
            
            behindLabel.text = newValue
            behindLabel.sizeToFit()
            behindLabel.frame.size.width = frontLabel.frame.width
            behindLabel.frame.origin.x = frontLabel.frame.maxX
            behindLabel.center.y = self.frame.height / 2
            
            if behindLabel.frame.width > self.frame.width {
                behindLabel.isHidden = false
                self.start()
            } else {
                behindLabel.isHidden = true
            }
        }
        get {
            return _content
        }
    }
    
    
    // MARK: - 跑马灯动画实现过程
    func marqueeAnimation() {
        let frontAnima = CABasicAnimation()
        frontAnima.keyPath = "position"
        frontAnima.fromValue = NSValue(cgPoint: CGPoint(x:  self.frontLabel.frame.width / 2 , y: self.frame.height / 2))
        frontAnima.toValue = NSValue(cgPoint: CGPoint(x: -1 * self.frontLabel.frame.width / 2, y: self.frame.height / 2))
        frontAnima.duration = self.time
//        frontAnima.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        frontAnima.repeatCount = MAXFLOAT
        
        let behindAnima = CABasicAnimation()
        behindAnima.keyPath = "position"
        behindAnima.fromValue = NSValue(cgPoint: CGPoint(x:  self.frontLabel.frame.width / 2 * 3 , y: self.frame.height / 2))
        behindAnima.toValue = NSValue(cgPoint: CGPoint(x:  self.frontLabel.frame.width / 2, y: self.frame.height / 2))
        behindAnima.duration = self.time
//        behindAnima.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        behindAnima.repeatCount = MAXFLOAT
        
        self.frontLabel.layer.add(frontAnima, forKey: "frontAnima")
        self.behindLabel.layer.add(behindAnima, forKey: "behindAnima")
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("Marquee - deinit")
    }
}
