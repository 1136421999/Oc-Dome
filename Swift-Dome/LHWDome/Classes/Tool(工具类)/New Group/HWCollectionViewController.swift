//
//  HWCollectionViewController.swift
//  LHWDome
//
//  Created by 李含文 on 2019/7/8.
//  Copyright © 2019年 李含文. All rights reserved.
//

import UIKit
import SnapKit
import EmptyDataSet_Swift

enum HWRefreshType : Int { // 刷新类型
    case `default` = 0 // 默认没有
    case dropDown = 1  // 只支持下拉
    case all = 2       // 支持上拉和下拉
}

class HWCollectionViewController: BaseViewController {

    /// 内部模型数组
    open lazy var itemArray = NSMutableArray()
    /// 角标
    open var page = 1
    /// 触发刷新就会来
    open func loadData() {}
    /// 刷新样式
    open var type = HWRefreshType.default {
        willSet {
           setRefresh(newValue)
        }
    }
    open var setCollectionViewFrameBlock:((UICollectionView)->())?
    /// 从新设置布局参数
    open var fl: UICollectionViewLayout? {
        willSet {
            guard newValue != nil else {
                return
            }
            self.collectionView.collectionViewLayout.invalidateLayout()
            collectionView.setCollectionViewLayout((newValue)!, animated: true)
        }
    }
    open lazy var collectionView : UICollectionView = {
        let fl = UICollectionViewFlowLayout()
        // myflowLayout.sectionHeadersPinToVisibleBounds = true // 头部悬浮
        fl.minimumLineSpacing = 0
        fl.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame:self.view.bounds, collectionViewLayout: fl)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
        return collectionView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        self.view.addSubview(self.collectionView)
    }
//    override func viewDidLayoutSubviews() {
//        if setCollectionViewFrameBlock == nil {
//            collectionView.snp.makeConstraints { (make) in
//                make.edges.equalToSuperview()
//            }
//        }
//    }
    /// 默认flowLayout样式
    open func setCollectionView(cellForItem: @escaping ((_ indexPath:IndexPath) -> UICollectionViewCell),
                           cellSize: @escaping ((_ indexPath:IndexPath) -> CGSize)) {
        cellForItemBlock = cellForItem
        cellSizeBlock = cellSize
    }
    open func setReusableView(headerViewSize: @escaping ((_ section : Int) -> CGSize),
                              footerViewSize: @escaping ((_ section : Int) -> CGSize),
                              reusableView: @escaping ((_ indexPath:IndexPath, _ kind: String) -> UICollectionReusableView)) {
        headerViewSizeBlock = headerViewSize
        footerViewSizeBlock = footerViewSize
        reusableViewBlock = reusableView
    }
    // MARK: - 闭包
    private var cellForItemBlock : ((_ index:IndexPath) -> UICollectionViewCell)?
    private var cellSizeBlock : ((_ index:IndexPath) -> CGSize)?
    private var headerViewSizeBlock : ((_ section : Int) -> CGSize)?
    private var footerViewSizeBlock : ((_ section : Int) -> CGSize)?
    private var reusableViewBlock : ((_ index:IndexPath, _ kind: String) -> UICollectionReusableView)?

    private func setRefresh(_ type: HWRefreshType) {
        switch type {
        case .default:
            collectionView.mj_header = nil
            collectionView.mj_footer = nil
        case .dropDown:
            collectionView.hw_hearderRefreshBlock = {
                self.page = 1
                self.loadData()
            }
        default:
            collectionView.hw_hearderRefreshBlock = {
                self.page = 1
                self.loadData()
            }
            collectionView.hw_footerRefreshBlock = {
                self.loadData()
            }
        }
    }
}
extension HWCollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return self.cellForItemBlock?(indexPath) ?? UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return self.reusableViewBlock?(indexPath, kind) ?? UICollectionReusableView()
    }
}
extension HWCollectionViewController : UICollectionViewDelegateFlowLayout{
    /// 设置cell CGSize
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.cellSizeBlock?(indexPath) ?? CGSize.zero
    }
    /// 设置headerView CGSize
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return self.headerViewSizeBlock?(section) ?? CGSize.zero
    }
    /// 设置footerView CGSize
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return self.footerViewSizeBlock?(section) ?? CGSize.zero
    }
}

// MARK: 隐藏上拉刷新
extension HWCollectionViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let size = scrollView.contentSize
        if size.height < collectionView.height{
            self.collectionView.mj_footer?.isHidden = true
        } else {
            self.collectionView.mj_footer?.isHidden = false
        }
    }
}

extension HWCollectionViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return hw_Image(named: "没数据缺省页")
    }
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return "暂无数据".hw_toAttribute().hw_color(UIColor.lightGray).hw_fontSize(15)
    }
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return -70
    }
    func emptyDataSet(_ scrollView: UIScrollView, didTapView view: UIView) {
        HWPrint("点击了屏幕")
    }
}
