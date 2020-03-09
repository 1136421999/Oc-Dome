//
//  HomeViewController.swift
//  LHWDome
//
//  Created by 李含文 on 2018/9/13.
//  Copyright © 2018年 李含文. All rights reserved.
//

import UIKit


extension Float {
    
    /// 小数点后如果只是0，显示整数，如果不是，显示原来的值
    var cleanZero : String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
    

class HomeViewController: HWCollectionViewController {

    var index = 0
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        index += 2560
        let bytes = index.hw_to4Bytes()
        HWPrint(bytes)
        let x = hw_getInt(bytes)
        HWPrint(x)
    }
    /// 虚线框
    func lineView() -> UIView {
        let lineView = UIView(frame: CGRect(x: 15, y: 12, width: HW_ScreenW - 30, height: 50))
        let border = CAShapeLayer()
        //虚线的颜色
        border.strokeColor = UIColor.red.cgColor
        //填充的颜色
        border.fillColor = HWBGColor().cgColor
        //设置路径
        let path = UIBezierPath(roundedRect: lineView.bounds, cornerRadius: 5)
        border.path = path.cgPath
        border.frame = lineView.bounds
        //虚线的宽度
        border.lineWidth = 1.0
        //设置线条的样式
        border.lineCap = "CAShapeLayerLineCap"
        //虚线的间隔
        border.lineDashPattern = [NSNumber(value: 8), NSNumber(value: 4)]
        lineView.layer.addSublayer(border)
        return lineView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        HWPrint("\(UIApplication.hw_getTopViewController()?.classForCoder)")
//        self.view.addSubview(lineView())
        let data = "123214214124".data(using: String.Encoding.utf8)
//        HWPrint("\(data) -- \(data?.count ?? 0)")
        let str = String(data: data!, encoding: String.Encoding.utf8)

        HWPrint(str)
//        setCollectionViewFrameBlock = { (collectionView) in
//            collectionView.snp.makeConstraints({ (make) in
//                make.top.equalTo(100)
//                make.right.bottom.left.equalToSuperview()
//            })
//        }
        let f: Float = 0.00000
        HWPrint("\(f.cleanZero)")
        setCollectionView()
        loadData()
//
//        ///---NSString查找字符串
//        ///---rangeOfString 方法查找一个字符串，此方法类型的结构体，若没有查找到对应的字符串，返回NSNotFound。
//        let str:NSString = "swift is new a new language ";
//        let rangeForStr = str.range(of: "new");
//        print("\(rangeForStr): \(str.substring(with: rangeForStr))");
//
//        let notFoundStr = str.range(of: "apple");
//        if notFoundStr.location == NSNotFound
//        {
//            print("not found");
//        }
//        else
//        {
//            print(notFoundStr);
//        }
//
//        ///---rangeOfString方法还可以传入一个option参数来设置查询方式，比如我们如果想查询的字符串不区分大小写，可以这样。如下所示
//        let rangeForStr2 = str.range(of: "new", options: NSString.CompareOptions.caseInsensitive);
//        print("\(rangeForStr2):\(str.substring(with: rangeForStr2))");
        
    }

    
    func setCollectionView() {
        weak var weakSelf = self // 弱引用
        collectionView.hw_registerCell(cell: HomeCell.self)
        type = .all
        setCollectionView(cellForItem: { (indexPath) -> UICollectionViewCell in
            return weakSelf!.getHomeCell(indexPath)
        }) { (indexPath) -> CGSize in
            return CGSize.init(width: HW_ScreenW, height: 50)
        }
    }
    func getHomeCell(_ indexPath: IndexPath) -> HomeCell {
        let cell = collectionView.hw_dequeueReusableCell(indexPath: indexPath) as HomeCell
        cell.backgroundColor = UIColor.red
        return cell
    }
    override func loadData() {
        if page == 1 {
            itemArray.removeAllObjects()
        }
        self.itemArray.addObjects(from: ["","","","","","","","","","","","","","","","","","","","","","","",""])
        self.collectionView.endRefreshing()
        self.collectionView.reloadData()
    }
}
