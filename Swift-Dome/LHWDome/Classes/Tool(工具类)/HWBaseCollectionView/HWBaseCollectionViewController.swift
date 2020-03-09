//
//  HWBaseCollectionViewController.swift
//  bobole
//
//  Created by Hanwen on 2018/4/21.
//  Copyright © 2018年 SK丿希望. All rights reserved.
//

import UIKit

enum RegisterType{ // cell 注册类型
    case Class //
    case Nib //
}
enum ReusableViewType{ // cell 注册类型
    case Header // 头部
    case Footer // 尾部
}

class HWBaseCollectionViewController: BaseViewController {
    
    // MARK: - 刷新相关
    private var _page : NSInteger = 0
    private var isEnterRefresh :Bool? // 是否进入刷新
    var isRefreshing :Bool=false // 是否正在刷新
    
    private var _noDataView : HWNoDataView?
    var noDataView : HWNoDataView? {
        set {
            _noDataView = newValue
            if _noDataView != nil {
                _noDataView?.removeFromSuperview()
            }
            newValue?.frame = collectionView.bounds
//            newValue?.isHidden = true
            collectionView.addSubview(newValue!)
        }
        get {
            return _noDataView
        }
    }
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
    /// 只有设置了刷新 (每次刷新会调用)
    func loadData(page: NSInteger) {}
    
    func setRefresh(isEnterRefresh : Bool,type : RefreshType) {
        self.isEnterRefresh = isEnterRefresh
        self.type = type
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isEnterRefresh != nil {
            if self.isEnterRefresh! {
                self.collectionView.mj_header.beginRefreshing()
            }
        }
    }
    // MARK: - 闭包
    private var cellForItemBlock : ((_ index:IndexPath) -> UICollectionViewCell)?
    private var cellSizeBlock : ((_ index:IndexPath) -> CGSize)?
    
    private var headerViewSizeBlock : ((_ section : Int) -> CGSize)?
    private var footerViewSizeBlock : ((_ section : Int) -> CGSize)?
    private var reusableViewBlock : ((_ index:IndexPath, _ kind: String) -> UICollectionReusableView)?
    
    // MARK: - 模型数组
    lazy var itemArray : NSMutableArray = {
        var arr = NSMutableArray.init()
        return arr
    }()
    private var _flowLayout: UICollectionViewLayout?
    /// 布局参数
    var flowLayout: UICollectionViewLayout? {
        set {
            _flowLayout = newValue
            if newValue == nil {return}
            self.collectionView.collectionViewLayout.invalidateLayout()
            collectionView.setCollectionViewLayout((newValue)!, animated: true)
        }
        get {
            return _flowLayout
        }
    }
    lazy var collectionView : UICollectionView = {
        let myflowLayout = UICollectionViewFlowLayout()
        // myflowLayout.sectionHeadersPinToVisibleBounds = true // 头部悬浮
        myflowLayout.minimumLineSpacing = 0
        myflowLayout.minimumInteritemSpacing = 0
        myflowLayout.headerReferenceSize = CGSize(width: HW_ScreenW, height: 0)
        myflowLayout.footerReferenceSize = CGSize(width: HW_ScreenW, height: 0)
        let collectionView = UICollectionView(frame:CGRect(x: 0, y: 0, width: HW_ScreenW, height: HW_ScreenH-hw_navigationH), collectionViewLayout: myflowLayout)
        if self.hidesBottomBarWhenPushed == false { // tabBar没隐藏
            collectionView.height -= hw_tabBarH
        } else { // tabBar隐藏
            if isiPhoneX {
                collectionView.height -= 34
            }
        }
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.actionBlock = { [weak self] (tag) in
            self?.noDataView?.isHidden = tag
        }
        return collectionView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = HWBGColor()
        self.noDataView = HWNoDataView.noDataView(image: nil, title: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    /// 注册cell
    func register(type: RegisterType ,name : String) ->  (){
        switch type {
        case .Class:
            collectionView.register(NSClassFromString(name), forCellWithReuseIdentifier: (name+"ID") as String)
            break
        case .Nib:
            collectionView.register(UINib.init(nibName: name, bundle: nil), forCellWithReuseIdentifier: (name+"ID") as String)
            break
        }
    }
    /// 自定义flowLayout样式
    func setCollectionView(flowLayout: UICollectionViewFlowLayout,
        cellForItem : @escaping ((_ index:IndexPath) -> UICollectionViewCell),
                           cellSize : @escaping ((_ index:IndexPath) -> CGSize)) {
        self.flowLayout = flowLayout
        cellForItemBlock = cellForItem
        cellSizeBlock = cellSize
        self.view.addSubview(self.collectionView)
    }
    /// 默认flowLayout样式
    func setCollectionView(cellForItem : @escaping ((_ index:IndexPath) -> UICollectionViewCell),
                           cellSize : @escaping ((_ index:IndexPath) -> CGSize)) {
        cellForItemBlock = cellForItem
        cellSizeBlock = cellSize
        self.view.addSubview(self.collectionView)
    }
    
    /// 注册ReusableView
    func registerReusableView(type: RegisterType ,reusableViewType : ReusableViewType,name : String) ->  (){
        switch type {
        case .Class:
            if reusableViewType == .Header {
                collectionView.register(NSClassFromString(name), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: (name+"ID") as String)
            } else {
                collectionView.register(NSClassFromString(name), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: (name+"ID") as String)
            }
            break
        case .Nib:
            if reusableViewType == .Header {
                collectionView.register(UINib.init(nibName: name, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: (name+"ID") as String)
            } else {
                collectionView.register(UINib.init(nibName: name, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: (name+"ID") as String)
            }
            break
        }
    }
    func setReusableView(headerViewSize : @escaping ((_ section : Int) -> CGSize),
                         footerViewSize : @escaping ((_ section : Int) -> CGSize),
                         reusableView : @escaping ((_ indexPath:IndexPath, _ kind: String) -> UICollectionReusableView)) {
        headerViewSizeBlock = headerViewSize
        footerViewSizeBlock = footerViewSize
        reusableViewBlock = reusableView
    }
    
}

extension HWBaseCollectionViewController :UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        noDataView?.isHidden =  self.itemArray.count > 0 ? true : false
        return self.itemArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.cellForItemBlock != nil {
            return self.cellForItemBlock!(indexPath)
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if self.reusableViewBlock != nil {
            return self.reusableViewBlock!(indexPath, kind)
        }
        return UICollectionReusableView()
    }
}

extension HWBaseCollectionViewController : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    // MARK: - 点击cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.cellSizeBlock != nil{
            return self.cellSizeBlock!(indexPath)
        }
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if self.headerViewSizeBlock != nil {
            return self.headerViewSizeBlock!(section)
        }
        return CGSize(width: 0, height: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if self.footerViewSizeBlock != nil {
            return self.footerViewSizeBlock!(section)
        }
        return CGSize(width: 0, height: 0)
    }
}
// MARK: - 刷新相关
extension HWBaseCollectionViewController {
    func addRefresh(type : RefreshType) {
        weak var weak = self
        switch type {
        case .Default:
            self.collectionView.mj_header = HWRefresh().my_heardWithRefreshingBlock(block: {
                if weak!.collectionView.mj_header.isRefreshing { // 在刷新过程中才走以下方法
                    weak!.page = 1
                }
            })
            weak!.collectionView.mj_footer = HWRefresh().my_footerWithRefreshingBlock(block: { 
                if weak!.collectionView.mj_footer.isRefreshing { // 在刷新过程中才走以下方法(注意:必须要不然在隐藏mj_footer会出现问题)
                    weak!.page = weak!.page+1
                }
            })
            break
        case .DropDown:
            weak!.collectionView.mj_header = HWRefresh().my_heardWithRefreshingBlock(block: { 
                if weak!.collectionView.mj_header.isRefreshing { // 在刷新过程中才走以下方法
                    weak!.page = 1
                }
            })
            break
        case .No:
            break
        }
        weak!.collectionView.mj_header?.beginRefreshing()
    }

    func endRefreshing() {
        weak var weakSelf = self // 弱引用
        weakSelf!.collectionView.mj_header?.endRefreshing()
        weakSelf!.collectionView.mj_footer?.endRefreshing()
    }
    func endRefreshingWithNoMoreData() {
        if self.collectionView.mj_footer == nil { return }
        self.collectionView.mj_footer.endRefreshingWithNoMoreData()
    }
}
// MARK: 隐藏上拉刷新
extension HWBaseCollectionViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        weak var weak = self
        let size = scrollView.contentSize
//        noDataView?.isHidden =  size.height > 20 ? true : false
        if size.height < collectionView.height{
            weak!.collectionView.mj_footer?.isHidden = true
        } else {
            weak!.collectionView.mj_footer?.isHidden = false
        }
    }
}
//extension HWBaseCollectionViewController {
//    func isiPhoneX() -> Bool {
//        if UIScreen.main.bounds.height == 812 {
//            return true
//        }
//        return false
//    }
//    func hw_tabBarH() -> CGFloat {
//        if isiPhoneX() {
//            return 83
//        }
//        return 49
//    }
//    func hw_autoY() -> CGFloat {
//        if isiPhoneX() {
//            return 88
//        }
//        return 64
//    }
//    // MARK: - 屏幕尺寸相关
//    func HWScreenW() -> CGFloat {
//        return  UIScreen.main.bounds.size.width
//    }
//    func HWScreenH() -> CGFloat {
//        return UIScreen.main.bounds.size.height
//    }
//}

//// MARK: 隐藏缺失页
//extension UICollectionView {
//    
//    public class func initializeMethod() {
//        
//        hw_exchangeInstance(method1: #selector(UICollectionView.reloadData), method2: #selector(UICollectionView.hw_reloadData))
//        hw_exchangeInstance(method1: #selector(UICollectionView.insertSections(_:)), method2: #selector(UICollectionView.hw_insertSections(_:)))
//        hw_exchangeInstance(method1: #selector(UICollectionView.deleteSections(_:)), method2: #selector(UICollectionView.hw_deleteSections(_:)))
//        hw_exchangeInstance(method1: #selector(UICollectionView.reloadSections(_:)), method2: #selector(UICollectionView.hw_reloadSections(_:)))
//        
//        hw_exchangeInstance(method1: #selector(UICollectionView.insertItems(at:)), method2: #selector(UICollectionView.hw_insertItems(at:)))
//        hw_exchangeInstance(method1: #selector(UICollectionView.deleteItems(at:)), method2: #selector(UICollectionView.hw_deleteItems(at:)))
//        hw_exchangeInstance(method1: #selector(UICollectionView.reloadItems(at:)), method2: #selector(UICollectionView.hw_reloadItems(at:)))
//    }
//    private static func  hw_exchangeInstance(method1:Selector, method2:Selector) {
//        let originalSelector = method1
//        let swizzledSelector = method2
//        
//        let originalMethod = class_getInstanceMethod(self, originalSelector)
//        let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
//        //在进行 Swizzling 的时候,需要用 class_addMethod 先进行判断一下原有类中是否有要替换方法的实现
//        let didAddMethod: Bool = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))
//        //如果 class_addMethod 返回 yes,说明当前类中没有要替换方法的实现,所以需要在父类中查找,这时候就用到 method_getImplemetation 去获取 class_getInstanceMethod 里面的方法实现,然后再进行 class_replaceMethod 来实现 Swizzing
//        if didAddMethod {
//            class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
//        } else {
//            method_exchangeImplementations(originalMethod!, swizzledMethod!)
//        }
//    }
//    
//    // 改进写法【推荐】
//    private struct RuntimeKey {
//        static let actionBlock = UnsafeRawPointer.init(bitPattern: "actionBlock".hashValue)
//        /// ...其他Key声明
//    }
//    /// 运行时关联
//    var actionBlock: ((Bool)->())? {
//        set {
//            objc_setAssociatedObject(self, UICollectionView.RuntimeKey.actionBlock!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
//        }
//        get {
//            return  objc_getAssociatedObject(self, UICollectionView.RuntimeKey.actionBlock!) as? ((Bool)->())
//        }
//    }
//    
//    @objc private func hw_reloadData() {
//        self.hw_reloadData()
//        hw_check()
//    }
//    
//    @objc private func hw_insertSections(_ sections: IndexSet) {
//        self.hw_insertSections(sections)
//        hw_check()
//    }
//    
//    @objc private func hw_deleteSections(_ sections: IndexSet) {
//        self.hw_deleteSections(sections)
//        hw_check()
//    }
//    
//    @objc private func hw_reloadSections(_ sections: IndexSet) {
//        self.hw_reloadSections(sections)
//        hw_check()
//    }
//    @objc private func hw_insertItems(at indexPaths: [IndexPath]) {
//        self.hw_insertItems(at: indexPaths)
//        hw_check()
//    }
//    
//    @objc private func hw_deleteItems(at indexPaths: [IndexPath]) {
//        self.hw_deleteItems(at: indexPaths)
//        hw_check()
//    }
//    @objc private func hw_reloadItems(at indexPaths: [IndexPath]) {
//        self.hw_reloadItems(at: indexPaths)
//        hw_check()
//    }
//    
//    private func totalDataCount() -> Int {
//        var totalCount = 0
//        for i in 0..<numberOfSections {
//            totalCount += numberOfItems(inSection: i)
//        }
//        return totalCount
//    }
//    private func hw_check() {
//        if actionBlock == nil {return}
//        actionBlock!(totalDataCount() == 0 ? false : true)
//    }
//}
