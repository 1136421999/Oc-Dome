//
//  ExampleViewController.swift
//  LHWDome
//
//  Created by 李含文 on 2018/9/29.
//  Copyright © 2018年 李含文. All rights reserved.
//

import UIKit

class ExampleViewController: HWBaseTableViewController {

    let titles = ["UITextField扩展","富文本扩展","按钮扩展","UILabel扩展", "自定义遮盖"]
    override func viewDidLoad() {
        super.viewDidLoad()
        setBGColor()
        setTableView()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    func setTableView() {
        tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0)
        setRefresh(isAllRefresh: false, type: .DropDown)
        setTableView(cellForRowBlock: { [weak self] (indexPath) -> UITableViewCell in
            return self!.getUITableViewCell(indexPath)
        }) { (indexPath) -> CGFloat in
            return 44
        }
    }
  
    override func loadData(page: NSInteger) {
        self.endRefreshing()
    }
    func getUITableViewCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.hw_dequeueReusableCell(indexPath: indexPath) as UITableViewCell
        let title = titles[indexPath.row]
        cell.textLabel?.text = title
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = titles[indexPath.row]
        if title == "UITextField扩展" {
            pushController(name: "UITextFieldExtensionViewController")
        } else if title == "富文本扩展" {
            pushController(name: "NSMutableAttributedStringExtensionViewController")
        } else if title == "按钮扩展" {
            pushController(name: "UIButtonExtensionViewController")
        } else if title == "自定义遮盖" {
            pushController(name: "HWCoverWindowViewController")
        } else if title == "UILabel扩展" {
            pushController(name: "UILabelExtensionViewController")
        }
        
    }
}
