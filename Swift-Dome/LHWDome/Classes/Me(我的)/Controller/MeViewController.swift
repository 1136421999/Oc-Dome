//
//  MeViewController.swift
//  LHWDome
//
//  Created by 李含文 on 2018/9/13.
//  Copyright © 2018年 李含文. All rights reserved.
//

import UIKit

class MeViewController: HWBaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setTableView()
    }
    func setTableView() {
//        setRefresh(isAllRefresh: false, type: .Default)
        setTableView(cellForRowBlock: { (indexPath) -> UITableViewCell in
            return self.getMeCell(indexPath)
        }) { (indexPath) -> CGFloat in
            return 50
        }
    }

    func getMeCell(_ indexPath: IndexPath) -> MeCell {
        let cell = tableView.hw_dequeueReusableCell(indexPath: indexPath) as MeCell
        cell.backgroundColor = indexPath.row%2 == 0 ? UIColor.red : UIColor.blue
        return cell
    }
    override func loadData(page: NSInteger) {
        weak var weakSelf = self
        if page == 1 {
            itemArray.removeAllObjects()
        }
        weakSelf!.itemArray.addObjects(from: ["","","","","","","","","","","","","","","","","","","","","","","",""])
        weakSelf!.endRefreshing()
        weakSelf!.tableView.reloadData()
    }
}
