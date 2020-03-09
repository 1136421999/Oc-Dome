//
//  UIScrollView+HWExtension.swift
//  UIScrollView扩展上下拉刷新
//
//  Created by 李含文 on 2018/11/27.
//  Copyright © 2018年 李含文. All rights reserved.
//
import UIKit
import MJRefresh

extension UIScrollView {
    
    private struct RuntimeKey {
        static let HearderRefreshBlockKey = UnsafeRawPointer.init(bitPattern: "HearderRefreshBlockKey".hashValue)
        static let FooterRefreshBlockKey = UnsafeRawPointer.init(bitPattern: "FooterRefreshBlockKey".hashValue)
    }
    /// 下拉刷新的回调
    var hw_hearderRefreshBlock: (()->())? {
        set {
            if mj_header == nil { addHearderRefresh() } // 如果不存在 就自动添加
            objc_setAssociatedObject(self, UIScrollView.RuntimeKey.HearderRefreshBlockKey!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, UIScrollView.RuntimeKey.HearderRefreshBlockKey!) as? (()->())
        }
    }
    /// 上拉刷新的回调
    var hw_footerRefreshBlock: (()->())? {
        set {
            if mj_footer == nil { addFooterRefresh() } // 如果不存在 就自动添加
            objc_setAssociatedObject(self, UIScrollView.RuntimeKey.FooterRefreshBlockKey!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, UIScrollView.RuntimeKey.FooterRefreshBlockKey!) as? (()->())
        }
    }
    
    /// 单独使用下拉刷新
    private func addHearderRefresh() {
        let header = MJRefreshNormalHeader { [weak self] in
            if self == nil {return}
            if self?.mj_footer?.isRefreshing == true { // 如果上拉正在执行 将其结束
                self?.mj_footer?.endRefreshing()
            }
            if self?.mj_header?.isRefreshing == true {
                self?.resetNoMoreData()
                self?.hw_hearderRefreshBlock?()
            }
        }
        mj_header = header
    }
    /// 单独使用上拉刷新
    private func addFooterRefresh() {
        let footer = MJRefreshBackNormalFooter { [weak self] in
            if self == nil {return}
            if self?.mj_header?.isRefreshing == true { // 如果下拉正在执行 将其结束
                self?.mj_header?.endRefreshing()
            }
            if self?.mj_footer?.isRefreshing == true {
                self?.hw_footerRefreshBlock?()
            }
        }
        mj_footer = footer
    }
    /// 结束刷新
    public func endRefreshing() {
        if mj_footer?.isRefreshing == true {
            mj_footer?.endRefreshing()
        }
        if mj_header?.isRefreshing == true  {
            mj_header?.endRefreshing()
        }
        
    }
    /// 开始刷新
    public func beginRefreshing() {
        mj_header?.beginRefreshing()
    }
    /// 结束刷新 并且设置没有更多数据
    public func endRefreshingWithNoMoreData(_ isNoMore: Bool) {
        endRefreshing()
        if isNoMore{
            mj_footer?.endRefreshingWithNoMoreData()
        }
    }
    
    /** 重置没有更多的数据（消除没有更多数据的状态） */
    public func resetNoMoreData() {
        if mj_footer?.state == .noMoreData {
            mj_footer?.resetNoMoreData()
        }
    }
}

