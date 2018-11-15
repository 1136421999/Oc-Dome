//
//  UICollectionView+HWExtension.swift
//
//  Created by Hanwen on 2018/7/9.
//  Copyright © 2018年 东莞市三心网络科技有限公司. All rights reserved.
//
import Foundation
import UIKit
/*
 使用说明
 1.collectionView调用hw_registerCell方法
 collectionView.hw_registerCell(cell: TextCell.self)
 2.获取Cell 注意: let cell = collectionView.hw_dequeueReusableCell(indexPath: indexPath) as TextCell 必须添加(as TextCell) 不然会崩溃
 func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.hw_dequeueReusableCell(indexPath: indexPath) as CollectionViewCell
    return cell
 }
 */
protocol UICollectionViewCellFromNib {}
extension UICollectionViewCellFromNib {
    static var identifier: String { return "\(self)ID" }
    static var nib: UINib? { return UINib(nibName: "\(self)", bundle: nil) }
    static func hw_getNibPath() -> String? {
        return Bundle.main.path(forResource: "\(self)", ofType: "nib")
    }
}

//extension UICollectionViewCell : UICollectionViewCellFromNib{}
extension UICollectionReusableView : UICollectionViewCellFromNib{}

extension UICollectionView {
    /// 注册 cell 的方法 注意:identifier是传入的 T+ID
    func hw_registerCell<T: UICollectionViewCell>(cell: T.Type) {
        if T.hw_getNibPath() != nil {
            register(T.nib, forCellWithReuseIdentifier: T.identifier)
        } else {
            register(cell, forCellWithReuseIdentifier: T.identifier)
        }
    }
    /// 从缓存池池出队已经存在的 cell
    func hw_dequeueReusableCell<T: UICollectionViewCell>(indexPath: IndexPath) -> T {
        if T.identifier == UICollectionViewCell.identifier {
            print("获取cell 后方必须固定添加(as 你的cell名称)")
            register(UICollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.identifier)
            return dequeueReusableCell(withReuseIdentifier: UICollectionViewCell.identifier, for: indexPath) as! T
        }
//        let cell = dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T
//        if cell == nil {
//            register(T.self, forCellWithReuseIdentifier: T.identifier)
//        }
        /// 如果这里报错 检查你是否注册cell
        return dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as! T
    }
    
    /// 注册头部
    func hw_registerCollectionHeaderView<T: UICollectionReusableView>(reusableView: T.Type) {
        // T 遵守了 RegisterCellOrNib 协议，所以通过 T 就能取出 identifier 这个属性
        if T.hw_getNibPath() != nil {
            register(T.nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: T.identifier)
        } else {
            register(reusableView, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: T.identifier)
        }
    }
    /// 获取可重用的头部
    func hw_dequeueCollectionHeaderView<T: UICollectionReusableView>(indexPath: IndexPath) -> T {
        if T.identifier == UICollectionReusableView.identifier {
            print("获取view 后方必须固定添加(as 你的view名称)")
            register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: UICollectionReusableView.identifier)
            return dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: UICollectionReusableView.identifier, for: indexPath) as! T
        }
        return dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: T.identifier, for: indexPath) as! T
    }
    /// 注册尾部
    func hw_registerCollectionFooterView<T: UICollectionReusableView>(reusableView: T.Type) {
        // T 遵守了 RegisterCellOrNib 协议，所以通过 T 就能取出 identifier 这个属性
        if T.hw_getNibPath() != nil {
            register(T.nib, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: T.identifier)
        } else {
            register(reusableView, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: T.identifier)
        }
    }
    /// 获取可重用的尾部
    func hw_dequeueCollectionFooterView<T: UICollectionReusableView>(indexPath: IndexPath) -> T {
        if T.identifier == UICollectionReusableView.identifier {
            print("获取view 后方必须固定添加(as 你的view名称)")
            register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: UICollectionReusableView.identifier)
            return dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: UICollectionReusableView.identifier, for: indexPath) as! T
        }
        return dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: T.identifier, for: indexPath) as! T
    }
}

