//
//  UITableView+HWExtension.swift
//
//  Created by Hanwen on 2018/7/9.
//  Copyright © 2018年 东莞市三心网络科技有限公司. All rights reserved.
//
import Foundation
import UIKit
/*
 使用说明
 1.tableView调用hw_registerCell方法
 tableView.hw_registerCell(cell: TextCell.self)
 2.获取Cell 注意: let cell = tableView.hw_dequeueReusableCell(indexPath: indexPath) as TextCell 必须添加(as TextCell) 不然会崩溃
 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 let cell = tableView.hw_dequeueReusableCell(indexPath: indexPath) as TextCell
 return cell
 }
 */
protocol TableViewCellFromNib {}
extension TableViewCellFromNib {
    static var identifier: String { return "\(self)ID" }
    static var nib: UINib? { return UINib(nibName: "\(self)", bundle: nil) }
    static func hw_getNibPath() -> String? {
        return Bundle.main.path(forResource: "\(self)", ofType: "nib")
    }
}
extension UITableViewCell : TableViewCellFromNib{}
extension UITableView {
    /// 注册 cell 的方法 注意:identifier是传入的 T+ID
    func hw_registerCell<T: UITableViewCell>(cell: T.Type) {
        if T.hw_getNibPath() != nil {
            register(T.nib, forCellReuseIdentifier: T.identifier)
        } else {
            register(cell, forCellReuseIdentifier: T.identifier)
        }
    }
    /// 从缓存池池出队已经存在的 cell
    func hw_dequeueReusableCell<T: UITableViewCell>(indexPath: IndexPath) -> T {
        if T.identifier == UITableViewCell.identifier {
            print("获取cell 后方必须固定添加(as 你的cell名称)")
            register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
            return dequeueReusableCell(withIdentifier: UITableViewCell.identifier, for: indexPath) as! T
        }
        let cell = dequeueReusableCell(withIdentifier: T.identifier) as? T
        if cell == nil {
            hw_registerCell(cell: T.self)
        }
        return dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as! T
    }
}

