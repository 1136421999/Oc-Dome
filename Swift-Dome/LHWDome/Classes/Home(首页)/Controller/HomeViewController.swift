//
//  HomeViewController.swift
//  LHWDome
//
//  Created by 李含文 on 2018/9/13.
//  Copyright © 2018年 李含文. All rights reserved.
//

import UIKit

class HomeViewController: HWBaseCollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        
        ///---NSString查找字符串
        ///---rangeOfString 方法查找一个字符串，此方法类型的结构体，若没有查找到对应的字符串，返回NSNotFound。
        let str:NSString = "swift is new a new language ";
        let rangeForStr = str.range(of: "new");
        print("\(rangeForStr): \(str.substring(with: rangeForStr))");
        
        let notFoundStr = str.range(of: "apple");
        if notFoundStr.location == NSNotFound
        {
            print("not found");
        }
        else
        {
            print(notFoundStr);
        }
        
        ///---rangeOfString方法还可以传入一个option参数来设置查询方式，比如我们如果想查询的字符串不区分大小写，可以这样。如下所示
        let rangeForStr2 = str.range(of: "new", options: NSString.CompareOptions.caseInsensitive);
        print("\(rangeForStr2):\(str.substring(with: rangeForStr2))");
        
    }

    func setCollectionView() {
        weak var weakSelf = self // 弱引用
        collectionView.hw_registerCell(cell: HomeCell.self)
        setRefresh(isEnterRefresh: false, type: .Default)
        setCollectionView(cellForItem: { (indexPath) -> UICollectionViewCell in
            return weakSelf!.getHomeCell(indexPath)
        }) { (indexPath) -> CGSize in
            return CGSize.init(width: HW_ScreenW, height: 50)
        }
    }
    func getHomeCell(_ indexPath: IndexPath) -> HomeCell {
        weak var weakSelf = self // 弱引用
        let cell = collectionView.hw_dequeueReusableCell(indexPath: indexPath) as HomeCell
        cell.backgroundColor = UIColor.red
        return cell
    }
    
    override func loadData(page: NSInteger) {
        weak var weakSelf = self
        if page == 1 {
            itemArray.removeAllObjects()
        }
        weakSelf!.itemArray.addObjects(from: ["","","","","","","","","","","","","","","","","","","","","","","",""])
        weakSelf!.endRefreshing()
        weakSelf!.collectionView.reloadData()
    }

}
