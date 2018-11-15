//
//  HWBasetableViewController.swift
//  SwifttableView封装
//
//  Created by Hanwen on 2018/3/6.
//  Copyright © 2018年 SK丿希望. All rights reserved.
//

import UIKit
//enum RegisterType{ // cell 注册类型
//    case Class //
//    case Nib //
//}
enum RefreshType{ // 刷新类型
    case Default // 支持上拉和下拉
    case DropDown // 只支持下拉
    case No // 没有刷新
}
class HWBaseTableViewController: BaseViewController {
    
    private var _noDataView : HWNoDataView?
    var noDataView : HWNoDataView? {
        set {
            _noDataView = newValue
            if _noDataView != nil {
                _noDataView?.removeFromSuperview()
            }
            newValue?.frame = tableView.bounds
            newValue?.isHidden = true
            tableView.addSubview(newValue!)
        }
        get {
            return _noDataView
        }
    }
    private var _page : NSInteger = 0
    private var page:NSInteger {
        get {
            return _page
        }
        set {
            _page = newValue
            self.isRefreshing = true
            self.loadData(page: newValue)
        }
    }
    // 当前是否在最底部
    var currentInsInBottom = false
    lazy var itemArray : NSMutableArray = {
        var arr = NSMutableArray.init()
        return arr
    }()
    lazy var tableView : UITableView = { // 懒加载
        let tableView = UITableView.init()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none // 清除分隔线
        tableView.showsVerticalScrollIndicator = false // 取消右侧滚动条
        self.view.addSubview(tableView)
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension;
//        if #available(iOS 11.0, *) {
//            tableView.contentInsetAdjustmentBehavior = .never
//        } else {
//            self.automaticallyAdjustsScrollViewInsets = false
//        }
        tableView.frame = CGRect.init(x: 0, y: 0, width: HWScreenW(), height: HWScreenH()-hw_navigationH())
        if self.hidesBottomBarWhenPushed == false{ // tabBar没隐藏
            tableView.height -= hw_tabBarH()
        } else { // tabBar隐藏
            if isiPhoneX() {
                tableView.height -= 34
            }
        }
        return tableView
    }()

    /// 闭包
    private var cellForRow: ((IndexPath) -> UITableViewCell)? // 设置Cell
    private var didSelectRow: ((IndexPath) -> ())? // 点击cell回调
    private var heightForRow: ((IndexPath) -> CGFloat)? // 设置Cell高度
    private var loadDataB: ((NSInteger) -> ())? // 刷新的回调
    private var isRefresh :Bool?
    var isRefreshing :Bool=false // 是否正在刷新
    private var _type : RefreshType?
    private var type : RefreshType?{
        get{
            return _type;
        }
        set{
            _type = newValue
            addRefresh(type: (newValue)!)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = HWBGColor()
        self.noDataView = HWNoDataView.noDataView(image: nil, title: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.type ==  RefreshType.No{
            self.page = 1
            return
        }
        if isRefresh != nil {
            if isRefresh == false {return}
            if self.tableView.mj_header?.isRefreshing == false{
                self.tableView.mj_header?.beginRefreshing()
            }
                
        }
    }
  
    /// 设置tableView
    /// - Parameters:
    ///   - cellForRowBlock: 设置cell的回调
    ///   - heightForRowBlock: 设置cell高度回调
    func setTableView(cellForRowBlock : @escaping ((IndexPath) -> UITableViewCell),
                      heightForRowBlock: @escaping ((IndexPath) -> CGFloat)
        ) {
        cellForRow = cellForRowBlock
        heightForRow = heightForRowBlock
    }
    
    /// 设置刷新
    ///
    /// - Parameters:
    ///   - isAllRefresh: 是否每次进入都刷新
    ///   - type: 刷新样式
    func setRefresh(isAllRefresh : Bool,
                    type : RefreshType) {
        self.type = type
        isRefresh = isAllRefresh
    }
    /// 不推荐使用
    func setTableView(isAllRefresh : Bool,
                      type : RefreshType,
                      cellForRowBlock : @escaping ((_ index:IndexPath) -> UITableViewCell),
                      heightForRowBlock: @escaping ((IndexPath) -> CGFloat),
                      didSelectRowBlock: @escaping ((IndexPath) -> ())
        ) {
        cellForRow = cellForRowBlock
        didSelectRow = didSelectRowBlock
        heightForRow = heightForRowBlock
        self.type = type
        isRefresh = isAllRefresh
    }
    /// 不推荐使用
    func setTableView(isAllRefresh : Bool,
                      type : RefreshType,
                      cellForRowBlock : @escaping ((_ index:IndexPath) -> UITableViewCell),
                      heightForRowBlock: @escaping ((IndexPath) -> CGFloat),
                      didSelectRowBlock: @escaping ((IndexPath) -> ()),
                      loadDataBlock: @escaping ((NSInteger) -> ())
        ) {
        cellForRow = cellForRowBlock
        didSelectRow = didSelectRowBlock
        heightForRow = heightForRowBlock
        self.type = type
        loadDataB = loadDataBlock
        isRefresh = isAllRefresh
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func loadData(page: NSInteger) {
        if self.loadDataB != nil {
            self.loadDataB!(self.page)
        }
    }
    deinit {
        print("HWBasetableViewController释放")
    }
}
// MARK: - UITableViewDataSource
extension HWBaseTableViewController :UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (self.cellForRow != nil) {
            return self.cellForRow!(indexPath)
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false) // 取消选中样式
        guard self.didSelectRow != nil else {
            return
        }
        self.didSelectRow!(indexPath)
    }
}
extension HWBaseTableViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard self.heightForRow != nil else {
            return 0
        }
        let size = tableView.contentSize
        if size.height < tableView.height{
            self.tableView.mj_footer?.isHidden = true
        } else {
            self.tableView.mj_footer?.isHidden = false
        }
        return self.heightForRow!(indexPath)
    }

//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if self.type == RefreshType.Default  {
//            if indexPath.row == itemArray.count-1 && itemArray.count>0 {
//                if !self.isRefreshing {
//                    self.page = self.page+1
//                    print("最后一行出现")
//                }
//            }
//        }
//    }
}
extension HWBaseTableViewController {
    func register(type: RegisterType ,name : String) ->  (){
        switch type {
        case .Class:
            self.tableView.register(NSClassFromString(name), forCellReuseIdentifier: (name+"ID") as String)
            break
        case .Nib:
            self.tableView.register(UINib.init(nibName: name, bundle: nil), forCellReuseIdentifier: (name+"ID") as String)
            break
        }
    }
}
// MARK: - 刷新相关
extension HWBaseTableViewController {
    func addRefresh(type : RefreshType) {
        weak var weak = self
        switch type {
        case .Default:
            self.tableView.mj_header = HWRefresh().my_heardWithRefreshingBlock(block: {
                if weak!.tableView.mj_header.isRefreshing { // 在刷新过程中才走以下方法
                    weak!.page = 1
                }
            })
            weak!.tableView.mj_footer = HWRefresh().my_footerWithRefreshingBlock(block: {
                if weak!.tableView.mj_footer.isRefreshing { // 在刷新过程中才走以下方法(注意:必须要不然在隐藏mj_footer会出现问题)
                    weak!.page = weak!.page+1
                }
            })
            break
        case .DropDown:
            weak!.tableView.mj_header = HWRefresh().my_heardWithRefreshingBlock(block: {
                if weak!.tableView.mj_header.isRefreshing { // 在刷新过程中才走以下方法
                    weak!.page = 1
                }
            })
            break
        case .No:
            break
        }
        weak!.tableView.mj_header?.beginRefreshing()
    }
    func endRefreshing() {
        weak var weakSelf = self // 弱引用
        weakSelf!.tableView.mj_header?.endRefreshing()
        weakSelf!.tableView.mj_footer?.endRefreshing()
    }
    func endRefreshingWithNoMoreData() {
        if self.tableView.mj_footer == nil { return }
        self.tableView.mj_footer.endRefreshingWithNoMoreData()
    }
}
// MARK: 隐藏上拉刷新
extension HWBaseTableViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        weak var weak = self
        let size = scrollView.contentSize
        noDataView?.isHidden =  size.height > 20 ? true : false
        if size.height < tableView.height{
            weak!.tableView.mj_footer?.isHidden = true
        } else {
            weak!.tableView.mj_footer?.isHidden = false
        }
    }
}
