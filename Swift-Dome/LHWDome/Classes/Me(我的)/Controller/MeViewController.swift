//
//  MeViewController.swift
//  LHWDome
//
//  Created by 李含文 on 2018/9/13.
//  Copyright © 2018年 李含文. All rights reserved.
//

import UIKit

class MeViewController: BaseViewController {//HWBaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        HWPrint("\(UIApplication.hw_getTopViewController()?.classForCoder)")
//        setTableView()
        setBackBtn(UIColor.red)
    }
    private var mod = true
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        mod = !mod
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return mod == true ? .lightContent : .default
    }
    override var prefersStatusBarHidden: Bool {
        return false
    }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.none
    }
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//        HUDManage?.hw_showtitleHUD(name: "请求成功")
////        HUDManage?.hw_showSuccessHUD(name: "请求成功请求成功请求成功请求成功请求成功请求成功请求成功请求成功请求成功请求成功请求成功请求成功请求成功")
////        HUDManage?.hw_showtitleHUD(name: "请求成功请求成功请求成功请求成功请求成功请求成功请求成功请求成功请求成功请求成功请求成功请求成功请求成功")
////        HUDManage?.hw_showErrorHUD(name: "请求成功请求成功请求成功请求成功请求成功请求成功请求成功请求成功请求成功请求成功请求成功请求成功请求成功")
////        HUDManage?.hw_showLoadingHUD()
//    }
//    func setTableView() {
////        setRefresh(isAllRefresh: false, type: .Default)
//        setTableView(cellForRowBlock: { (indexPath) -> UITableViewCell in
//            return self.getMeCell(indexPath)
//        }) { (indexPath) -> CGFloat in
//            return 50
//        }
//    }
//
//    func getMeCell(_ indexPath: IndexPath) -> MeCell {
//        let cell = tableView.hw_dequeueReusableCell(indexPath: indexPath) as MeCell
//        cell.backgroundColor = indexPath.row%2 == 0 ? UIColor.red : UIColor.blue
//        return cell
//    }
//    override func loadData(page: NSInteger) {
//        weak var weakSelf = self
//        if page == 1 {
//            itemArray.removeAllObjects()
//        }
//        weakSelf!.itemArray.addObjects(from: ["","","","","","","","","","","","","","","","","","","","","","","",""])
//        weakSelf!.endRefreshing()
//        weakSelf!.tableView.reloadData()
//    }
}
